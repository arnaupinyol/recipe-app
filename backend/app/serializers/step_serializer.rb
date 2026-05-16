class StepSerializer
  def self.render(step)
    step_images = step.step_images.sort_by(&:id)

    {
      id: step.id,
      recipe_id: step.recipe_id,
      recipe_title: step.recipe.title,
      description: step.description,
      order_number: step.order_number,
      timer_seconds: step.timer_seconds,
      step_image_ids: step_images.map(&:id),
      image_urls: step_images.map { |step_image| AttachmentUrlHelper.url_for(step_image.image) }.compact,
      images_count: step_images.size,
      created_at: step.created_at,
      updated_at: step.updated_at
    }
  end
end
