class StepSerializer
  def self.render(step)
    {
      id: step.id,
      recipe_id: step.recipe_id,
      recipe_title: step.recipe.title,
      description: step.description,
      order_number: step.order_number,
      timer_seconds: step.timer_seconds,
      step_image_ids: step.step_images.order(:id).pluck(:id),
      images_count: step.step_images.size,
      created_at: step.created_at,
      updated_at: step.updated_at
    }
  end
end
