class StepImageSerializer
  def self.render(step_image)
    {
      id: step_image.id,
      step_id: step_image.step_id,
      step_order_number: step_image.step.order_number,
      recipe_id: step_image.step.recipe_id,
      recipe_title: step_image.step.recipe.title,
      url: step_image.url,
      created_at: step_image.created_at,
      updated_at: step_image.updated_at
    }
  end
end
