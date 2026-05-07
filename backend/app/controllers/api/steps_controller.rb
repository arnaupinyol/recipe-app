module Api
  class StepsController < BaseController
    before_action :set_step, only: [ :show, :update, :destroy ]

    def index
      steps = Step.includes(:recipe, :step_images).order(:recipe_id, :order_number)

      render_success({ steps: steps.map { |step| StepSerializer.render(step) } })
    end

    def show
      render_success({ step: StepSerializer.render(@step) })
    end

    def create
      step = Step.new(step_params)

      if step.save
        render_success({ step: StepSerializer.render(step) }, status: :created)
      else
        render_error("Step creation failed", details: normalized_step_errors(step))
      end
    end

    def update
      if @step.update(step_params)
        render_success({ step: StepSerializer.render(@step) })
      else
        render_error("Step update failed", details: normalized_step_errors(@step))
      end
    end

    def destroy
      @step.destroy
      render_success({ message: "Step deleted" })
    end

    private

    def set_step
      @step = Step.includes(:recipe, :step_images).find_by(id: params[:id])
      return if @step

      render_error("Step not found", status: :not_found)
    end

    def step_params
      params.require(:step).permit(:recipe_id, :description, :order_number, :timer_seconds)
    end

    def normalized_step_errors(step)
      details = step.errors.to_hash

      if details.delete(:recipe) == [ "must exist" ]
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
