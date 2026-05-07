module Api
  class RecipeImagesController < BaseController
    before_action :set_recipe_image, only: [ :show, :update, :destroy ]

    def index
      recipe_images = RecipeImage.includes(:recipe).order(:recipe_id, :id)

      render_success({ recipe_images: recipe_images.map { |recipe_image| RecipeImageSerializer.render(recipe_image) } })
    end

    def show
      render_success({ recipe_image: RecipeImageSerializer.render(@recipe_image) })
    end

    def create
      recipe_image = RecipeImage.new(recipe_image_params)

      if recipe_image.save
        render_success({ recipe_image: RecipeImageSerializer.render(recipe_image) }, status: :created)
      else
        render_error("Recipe image creation failed", details: normalized_recipe_image_errors(recipe_image))
      end
    end

    def update
      if @recipe_image.update(recipe_image_params)
        render_success({ recipe_image: RecipeImageSerializer.render(@recipe_image) })
      else
        render_error("Recipe image update failed", details: normalized_recipe_image_errors(@recipe_image))
      end
    end

    def destroy
      @recipe_image.destroy
      render_success({ message: "Recipe image deleted" })
    end

    private

    def set_recipe_image
      @recipe_image = RecipeImage.includes(:recipe).find_by(id: params[:id])
      return if @recipe_image

      render_error("Recipe image not found", status: :not_found)
    end

    def recipe_image_params
      params.require(:recipe_image).permit(:recipe_id, :url)
    end

    def normalized_recipe_image_errors(recipe_image)
      details = recipe_image.errors.to_hash

      if details.delete(:recipe) == [ "must exist" ]
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
