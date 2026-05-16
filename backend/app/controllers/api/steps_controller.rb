module Api
  class StepsController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_step, only: [ :show, :update, :destroy ]
    before_action :authorize_step_modification!, only: [ :update, :destroy ]

    def index
      steps = visible_steps_scope.order(:recipe_id, :order_number)

      render_success({ steps: steps.map { |step| StepSerializer.render(step) } })
    end

    def show
      render_success({ step: StepSerializer.render(@step) })
    end

    def create
      return unless ensure_editable_recipe_param!("Step creation failed")

      step = Step.new(step_params)

      if step.save
        render_success({ step: StepSerializer.render(step) }, status: :created)
      else
        render_error("Step creation failed", details: normalized_step_errors(step))
      end
    end

    def update
      return unless ensure_editable_recipe_param!("Step update failed")

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

    def visible_steps_scope
      Step.includes(:recipe, step_images: { image_attachment: :blob }).joins(:recipe).merge(visible_recipes_relation)
    end

    def authorize_step_modification!
      return if current_user&.admin? || @step.recipe.user_id == current_user.id

      render_forbidden
    end

    def ensure_editable_recipe_param!(message)
      recipe_id = params.dig(:step, :recipe_id)
      return true if recipe_id.blank? || editable_recipes_relation.where(id: recipe_id).exists?

      render_error(message, details: { recipe_id: [ "contains an invalid value" ] })
      false
    end

    def set_step
      @step = visible_steps_scope.find_by(id: params[:id])
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
