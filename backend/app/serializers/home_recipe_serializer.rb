class HomeRecipeSerializer
  def self.render(recipe, current_user: nil, base_url: nil)
    recipe_images = recipe.recipe_images.sort_by(&:id)
    ingredients = recipe.recipe_ingredients.sort_by(&:id)
    steps = recipe.steps.sort_by(&:order_number)

    {
      id: recipe.id,
      user_id: recipe.user_id,
      username: recipe.user.username,
      title: recipe.title,
      description: recipe.description,
      preparation_time_minutes: recipe.preparation_time_minutes,
      difficulty: recipe.difficulty,
      servings: recipe.servings,
      visibility: recipe.visibility,
      likes_count: recipe.likes_count,
      saves_count: recipe.saves_count,
      comments_count: recipe.comments.size,
      image_urls: recipe_images.map { |recipe_image| AttachmentUrlHelper.url_for(recipe_image.image, base_url: base_url) }.compact,
      categories: recipe.categories.order(:name).map do |category|
        {
          id: category.id,
          name: category.name
        }
      end,
      ingredients: ingredients.map do |recipe_ingredient|
        ingredient = recipe_ingredient.ingredient

        {
          id: recipe_ingredient.id,
          ingredient_id: ingredient.id,
          name: ingredient.name,
          quantity: recipe_ingredient.quantity,
          unit_type: recipe_ingredient.unit_type,
          notes: recipe_ingredient.notes,
          image_url: AttachmentUrlHelper.url_for(ingredient.image, base_url: base_url)
        }
      end,
      steps: steps.map do |step|
        step_images = step.step_images.sort_by(&:id)

        {
          id: step.id,
          description: step.description,
          order_number: step.order_number,
          timer_seconds: step.timer_seconds,
          image_urls: step_images.map { |step_image| AttachmentUrlHelper.url_for(step_image.image, base_url: base_url) }.compact
        }
      end,
      liked_by_current_user: liked_by_current_user?(recipe, current_user),
      saved_by_current_user: saved_by_current_user?(recipe, current_user),
      created_at: recipe.created_at,
      updated_at: recipe.updated_at
    }
  end

  def self.liked_by_current_user?(recipe, current_user)
    return false unless current_user

    recipe.user_recipe_likes.any? { |like| like.user_id == current_user.id }
  end
  private_class_method :liked_by_current_user?

  def self.saved_by_current_user?(recipe, current_user)
    return false unless current_user

    recipe.user_saved_recipes.any? { |saved_recipe| saved_recipe.user_id == current_user.id }
  end
  private_class_method :saved_by_current_user?
end
