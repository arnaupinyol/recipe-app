module Api
  class RecipeImagesController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_recipe_image, only: [ :show, :update, :destroy ]
    before_action :authorize_recipe_image_modification!, only: [ :update, :destroy ]

    def index
      recipe_images = visible_recipe_images_scope.order(:recipe_id, :id)

      render_success({ recipe_images: recipe_images.map { |recipe_image| RecipeImageSerializer.render(recipe_image) } })
    end

    def show
      render_success({ recipe_image: RecipeImageSerializer.render(@recipe_image) })
    end

    def create
      return unless ensure_editable_recipe_param!("Recipe image creation failed")

      recipe_image = RecipeImage.new(recipe_image_params)

      if recipe_image.save
        render_success({ recipe_image: RecipeImageSerializer.render(recipe_image) }, status: :created)
      else
        render_error("Recipe image creation failed", details: normalized_recipe_image_errors(recipe_image))
      end
    end

    def update
      return unless ensure_editable_recipe_param!("Recipe image update failed")

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

    def visible_recipe_images_scope
      RecipeImage.includes(:recipe, image_attachment: :blob).joins(:recipe).merge(visible_recipes_relation)
    end

    def authorize_recipe_image_modification!
      return if current_user&.admin? || @recipe_image.recipe.user_id == current_user.id

      render_forbidden
    end

    def ensure_editable_recipe_param!(message)
      recipe_id = params.dig(:recipe_image, :recipe_id)
      return true if recipe_id.blank? || editable_recipes_relation.where(id: recipe_id).exists?

      render_error(message, details: { recipe_id: [ "contains an invalid value" ] })
      false
    end

    def set_recipe_image
      @recipe_image = visible_recipe_images_scope.find_by(id: params[:id])
      return if @recipe_image

      render_error("Recipe image not found", status: :not_found)
    end

    def recipe_image_params
      params.require(:recipe_image).permit(:recipe_id, :image)
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
