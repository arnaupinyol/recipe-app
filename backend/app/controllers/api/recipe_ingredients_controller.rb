module Api
  class RecipeIngredientsController < BaseController
    before_action :set_recipe_ingredient, only: [ :show, :update, :destroy ]

    def index
      recipe_ingredients = RecipeIngredient.includes(:recipe, :ingredient).order(:recipe_id, :id)

      render_success({ recipe_ingredients: recipe_ingredients.map { |recipe_ingredient| RecipeIngredientSerializer.render(recipe_ingredient) } })
    end

    def show
      render_success({ recipe_ingredient: RecipeIngredientSerializer.render(@recipe_ingredient) })
    end

    def create
      recipe_ingredient = RecipeIngredient.new(recipe_ingredient_params)

      if recipe_ingredient.save
        render_success({ recipe_ingredient: RecipeIngredientSerializer.render(recipe_ingredient) }, status: :created)
      else
        render_error("Recipe ingredient creation failed", details: normalized_recipe_ingredient_errors(recipe_ingredient))
      end
    end

    def update
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

    def set_recipe_ingredient
      @recipe_ingredient = RecipeIngredient.includes(:recipe, :ingredient).find_by(id: params[:id])
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
