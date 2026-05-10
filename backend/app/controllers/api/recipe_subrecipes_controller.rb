module Api
  class RecipeSubrecipesController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_recipe_subrecipe, only: [ :show, :update, :destroy ]
    before_action :authorize_recipe_subrecipe_modification!, only: [ :update, :destroy ]

    def index
      recipe_subrecipes = visible_recipe_subrecipes_scope.order(:recipe_id, :id)

      render_success({ recipe_subrecipes: recipe_subrecipes.map { |recipe_subrecipe| RecipeSubrecipeSerializer.render(recipe_subrecipe) } })
    end

    def show
      render_success({ recipe_subrecipe: RecipeSubrecipeSerializer.render(@recipe_subrecipe) })
    end

    def create
      return unless ensure_accessible_recipe_params!("Recipe subrecipe creation failed")

      recipe_subrecipe = RecipeSubrecipe.new(recipe_subrecipe_params)

      if recipe_subrecipe.save
        render_success({ recipe_subrecipe: RecipeSubrecipeSerializer.render(recipe_subrecipe) }, status: :created)
      else
        render_error("Recipe subrecipe creation failed", details: normalized_recipe_subrecipe_errors(recipe_subrecipe))
      end
    end

    def update
      return unless ensure_accessible_recipe_params!("Recipe subrecipe update failed")

      if @recipe_subrecipe.update(recipe_subrecipe_params)
        render_success({ recipe_subrecipe: RecipeSubrecipeSerializer.render(@recipe_subrecipe) })
      else
        render_error("Recipe subrecipe update failed", details: normalized_recipe_subrecipe_errors(@recipe_subrecipe))
      end
    end

    def destroy
      @recipe_subrecipe.destroy
      render_success({ message: "Recipe subrecipe deleted" })
    end

    private

    def visible_recipe_subrecipes_scope
      RecipeSubrecipe.includes(:recipe, :subrecipe)
        .joins(:recipe)
        .merge(visible_recipes_relation)
        .where(subrecipe_id: visible_recipes_relation.select(:id))
    end

    def authorize_recipe_subrecipe_modification!
      return if current_user&.admin? || @recipe_subrecipe.recipe.user_id == current_user.id

      render_forbidden
    end

    def ensure_accessible_recipe_params!(message)
      details = {}

      recipe_id = params.dig(:recipe_subrecipe, :recipe_id)
      if recipe_id.present? && !editable_recipes_relation.where(id: recipe_id).exists?
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      subrecipe_id = params.dig(:recipe_subrecipe, :subrecipe_id)
      if subrecipe_id.present? && !visible_recipes_relation.where(id: subrecipe_id).exists?
        details[:subrecipe_id] = [ "contains an invalid value" ]
      end

      return true if details.empty?

      render_error(message, details: details)
      false
    end

    def set_recipe_subrecipe
      @recipe_subrecipe = visible_recipe_subrecipes_scope.find_by(id: params[:id])
      return if @recipe_subrecipe

      render_error("Recipe subrecipe not found", status: :not_found)
    end

    def recipe_subrecipe_params
      params.require(:recipe_subrecipe).permit(:recipe_id, :subrecipe_id, :quantity, :unit_type, :notes)
    end

    def normalized_recipe_subrecipe_errors(recipe_subrecipe)
      details = recipe_subrecipe.errors.to_hash

      if details.delete(:recipe) == [ "must exist" ]
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      if details.delete(:subrecipe) == [ "must exist" ]
        details[:subrecipe_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
