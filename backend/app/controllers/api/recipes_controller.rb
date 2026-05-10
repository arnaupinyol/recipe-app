module Api
  class RecipesController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_recipe, only: [ :show, :update, :destroy ]
    before_action :authorize_recipe_modification!, only: [ :update, :destroy ]

    def index
      recipes = visible_recipes_relation.includes(:user, :categories, :utensils).order(created_at: :desc)

      render_success({ recipes: recipes.map { |recipe| RecipeSerializer.render(recipe) } })
    end

    def show
      render_success({ recipe: RecipeSerializer.render(@recipe) })
    end

    def create
      recipe = current_user.recipes.new(recipe_attributes)
      assign_recipe_relations(recipe)

      if recipe.save
        render_success({ recipe: RecipeSerializer.render(recipe) }, status: :created)
      else
        render_error("Recipe creation failed", details: normalized_recipe_errors(recipe))
      end
    rescue ActiveRecord::RecordNotFound
      render_error("Recipe creation failed", details: invalid_relation_details)
    end

    def update
      @recipe.assign_attributes(recipe_attributes)
      assign_recipe_relations(@recipe)

      if @recipe.save
        render_success({ recipe: RecipeSerializer.render(@recipe) })
      else
        render_error("Recipe update failed", details: normalized_recipe_errors(@recipe))
      end
    rescue ActiveRecord::RecordNotFound
      render_error("Recipe update failed", details: invalid_relation_details)
    end

    def destroy
      @recipe.destroy
      render_success({ message: "Recipe deleted" })
    end

    private

    def authorize_recipe_modification!
      return if current_user&.admin? || @recipe.user_id == current_user.id

      render_forbidden
    end

    def set_recipe
      @recipe = visible_recipes_relation.includes(:user, :categories, :utensils).find_by(id: params[:id])
      return if @recipe

      render_error("Recipe not found", status: :not_found)
    end

    def recipe_params
      params.require(:recipe).permit(
        :title,
        :description,
        :preparation_time_minutes,
        :difficulty,
        :servings,
        :visibility,
        :can_be_ingredient,
        category_ids: [],
        utensil_ids: []
      )
    end

    def recipe_attributes
      recipe_params.except(:category_ids, :utensil_ids)
    end

    def assign_recipe_relations(recipe)
      category_ids = Array(recipe_params[:category_ids]).reject(&:blank?)
      utensil_ids = Array(recipe_params[:utensil_ids]).reject(&:blank?)

      recipe.categories = Category.find(category_ids) if recipe_params.key?(:category_ids)
      recipe.utensils = Utensil.find(utensil_ids) if recipe_params.key?(:utensil_ids)
    end

    def normalized_recipe_errors(recipe)
      details = recipe.errors.to_hash
      details
    end

    def invalid_relation_details
      details = {}

      category_ids = Array(params.dig(:recipe, :category_ids)).reject(&:blank?)
      if category_ids.any? && Category.where(id: category_ids).count != category_ids.size
        details[:category_ids] = [ "contain invalid values" ]
      end

      utensil_ids = Array(params.dig(:recipe, :utensil_ids)).reject(&:blank?)
      if utensil_ids.any? && Utensil.where(id: utensil_ids).count != utensil_ids.size
        details[:utensil_ids] = [ "contain invalid values" ]
      end

      details.presence || { base: [ "contains invalid relations" ] }
    end
  end
end
