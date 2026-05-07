module Api
  class RecipeSubrecipesController < BaseController
    before_action :set_recipe_subrecipe, only: [ :show, :update, :destroy ]

    def index
      recipe_subrecipes = RecipeSubrecipe.includes(:recipe, :subrecipe).order(:recipe_id, :id)

      render_success({ recipe_subrecipes: recipe_subrecipes.map { |recipe_subrecipe| RecipeSubrecipeSerializer.render(recipe_subrecipe) } })
    end

    def show
      render_success({ recipe_subrecipe: RecipeSubrecipeSerializer.render(@recipe_subrecipe) })
    end

    def create
      recipe_subrecipe = RecipeSubrecipe.new(recipe_subrecipe_params)

      if recipe_subrecipe.save
        render_success({ recipe_subrecipe: RecipeSubrecipeSerializer.render(recipe_subrecipe) }, status: :created)
      else
        render_error("Recipe subrecipe creation failed", details: normalized_recipe_subrecipe_errors(recipe_subrecipe))
      end
    end

    def update
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

    def set_recipe_subrecipe
      @recipe_subrecipe = RecipeSubrecipe.includes(:recipe, :subrecipe).find_by(id: params[:id])
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
