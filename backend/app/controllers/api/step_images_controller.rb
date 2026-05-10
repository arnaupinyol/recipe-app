module Api
  class StepImagesController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_step_image, only: [ :show, :update, :destroy ]
    before_action :authorize_step_image_modification!, only: [ :update, :destroy ]

    def index
      step_images = visible_step_images_scope.order(:step_id, :id)

      render_success({ step_images: step_images.map { |step_image| StepImageSerializer.render(step_image) } })
    end

    def show
      render_success({ step_image: StepImageSerializer.render(@step_image) })
    end

    def create
      return unless ensure_editable_step_param!("Step image creation failed")

      step_image = StepImage.new(step_image_params)

      if step_image.save
        render_success({ step_image: StepImageSerializer.render(step_image) }, status: :created)
      else
        render_error("Step image creation failed", details: normalized_step_image_errors(step_image))
      end
    end

    def update
      return unless ensure_editable_step_param!("Step image update failed")

      if @step_image.update(step_image_params)
        render_success({ step_image: StepImageSerializer.render(@step_image) })
      else
        render_error("Step image update failed", details: normalized_step_image_errors(@step_image))
      end
    end

    def destroy
      @step_image.destroy
      render_success({ message: "Step image deleted" })
    end

    private

    def visible_step_images_scope
      StepImage.includes(step: :recipe).joins(step: :recipe).merge(visible_recipes_relation)
    end

    def editable_steps_scope
      Step.includes(:recipe).joins(:recipe).merge(editable_recipes_relation)
    end

    def authorize_step_image_modification!
      return if current_user&.admin? || @step_image.step.recipe.user_id == current_user.id

      render_forbidden
    end

    def ensure_editable_step_param!(message)
      step_id = params.dig(:step_image, :step_id)
      return true if step_id.blank? || editable_steps_scope.where(id: step_id).exists?

      render_error(message, details: { step_id: [ "contains an invalid value" ] })
      false
    end

    def set_step_image
      @step_image = visible_step_images_scope.find_by(id: params[:id])
      return if @step_image

      render_error("Step image not found", status: :not_found)
    end

    def step_image_params
      params.require(:step_image).permit(:step_id, :url)
    end

    def normalized_step_image_errors(step_image)
      details = step_image.errors.to_hash

      if details.delete(:step) == [ "must exist" ]
        details[:step_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
