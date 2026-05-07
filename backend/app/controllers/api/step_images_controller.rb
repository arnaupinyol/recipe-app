module Api
  class StepImagesController < BaseController
    before_action :set_step_image, only: [ :show, :update, :destroy ]

    def index
      step_images = StepImage.includes(step: :recipe).order(:step_id, :id)

      render_success({ step_images: step_images.map { |step_image| StepImageSerializer.render(step_image) } })
    end

    def show
      render_success({ step_image: StepImageSerializer.render(@step_image) })
    end

    def create
      step_image = StepImage.new(step_image_params)

      if step_image.save
        render_success({ step_image: StepImageSerializer.render(step_image) }, status: :created)
      else
        render_error("Step image creation failed", details: normalized_step_image_errors(step_image))
      end
    end

    def update
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

    def set_step_image
      @step_image = StepImage.includes(step: :recipe).find_by(id: params[:id])
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
