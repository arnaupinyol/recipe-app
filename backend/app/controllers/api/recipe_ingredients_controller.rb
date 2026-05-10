module Api
  class RecipeIngredientsController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_recipe_ingredient, only: [ :show, :update, :destroy ]
    before_action :authorize_recipe_ingredient_modification!, only: [ :update, :destroy ]

    def index
      recipe_ingredients = visible_recipe_ingredients_scope.order(:recipe_id, :id)

      render_success({ recipe_ingredients: recipe_ingredients.map { |recipe_ingredient| RecipeIngredientSerializer.render(recipe_ingredient) } })
    end

    def show
      render_success({ recipe_ingredient: RecipeIngredientSerializer.render(@recipe_ingredient) })
    end

    def create
      return unless ensure_editable_recipe_param!("Recipe ingredient creation failed")

      recipe_ingredient = RecipeIngredient.new(recipe_ingredient_params)

      if recipe_ingredient.save
        render_success({ recipe_ingredient: RecipeIngredientSerializer.render(recipe_ingredient) }, status: :created)
      else
        render_error("Recipe ingredient creation failed", details: normalized_recipe_ingredient_errors(recipe_ingredient))
      end
    end

    def update
      return unless ensure_editable_recipe_param!("Recipe ingredient update failed")

      if @recipe_ingredient.update(recipe_ingredient_params)
        render_success({ recipe_ingredient: RecipeIngredientSerializer.render(@recipe_ingredient) })
      else
        render_error("Recipe ingredient update failed", details: normalized_recipe_ingredient_errors(@recipe_ingredient))
      end
    end

    def destroy
      @recipe_ingredient.destroy
      render_success({ message: "Recipe ingredient deleted" })
    end

    private

    def visible_recipe_ingredients_scope
      RecipeIngredient.includes(:recipe, :ingredient).joins(:recipe).merge(visible_recipes_relation)
    end

    def authorize_recipe_ingredient_modification!
      return if current_user&.admin? || @recipe_ingredient.recipe.user_id == current_user.id

      render_forbidden
    end

    def ensure_editable_recipe_param!(message)
      recipe_id = params.dig(:recipe_ingredient, :recipe_id)
      return true if recipe_id.blank? || editable_recipes_relation.where(id: recipe_id).exists?

      render_error(message, details: { recipe_id: [ "contains an invalid value" ] })
      false
    end

    def set_recipe_ingredient
      @recipe_ingredient = visible_recipe_ingredients_scope.find_by(id: params[:id])
      return if @recipe_ingredient

      render_error("Recipe ingredient not found", status: :not_found)
    end

    def recipe_ingredient_params
      params.require(:recipe_ingredient).permit(:recipe_id, :ingredient_id, :quantity, :unit_type, :notes)
    end

    def normalized_recipe_ingredient_errors(recipe_ingredient)
      details = recipe_ingredient.errors.to_hash

      if details.delete(:recipe) == [ "must exist" ]
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      if details.delete(:ingredient) == [ "must exist" ]
        details[:ingredient_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
