module Api
  class IngredientsController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :require_staff!, only: [ :create, :update, :destroy ]
    before_action :set_ingredient, only: [ :show, :update, :destroy ]

    def index
      ingredients = Ingredient.includes(:allergies, image_attachment: :blob).order(:name)

      render_success({ ingredients: ingredients.map { |ingredient| IngredientSerializer.render(ingredient) } })
    end

    def show
      render_success({ ingredient: IngredientSerializer.render(@ingredient) })
    end

    def create
      ingredient = Ingredient.new(ingredient_params)

      if ingredient.save
        render_success({ ingredient: IngredientSerializer.render(ingredient) }, status: :created)
      else
        render_error("Ingredient creation failed", details: ingredient.errors.to_hash)
      end
    end

    def update
      if @ingredient.update(ingredient_params)
        render_success({ ingredient: IngredientSerializer.render(@ingredient) })
      else
        render_error("Ingredient update failed", details: @ingredient.errors.to_hash)
      end
    end

    def destroy
      @ingredient.destroy
      render_success({ message: "Ingredient deleted" })
    rescue ActiveRecord::DeleteRestrictionError
      render_error("Ingredient cannot be deleted because it is associated with recipes or shopping lists", status: :conflict)
    end

    private

    def set_ingredient
      @ingredient = Ingredient.includes(:allergies, image_attachment: :blob).find_by(id: params[:id])
      return if @ingredient

      render_error("Ingredient not found", status: :not_found)
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :image, :optional_description, allergy_ids: [])
    end
  end
end
