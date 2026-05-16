class RecipeSerializer
  def self.render(recipe)
    recipe_images = recipe.recipe_images.sort_by(&:id)

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
      can_be_ingredient: recipe.can_be_ingredient,
      likes_count: recipe.likes_count,
      saves_count: recipe.saves_count,
      recipe_image_ids: recipe_images.map(&:id),
      image_urls: recipe_images.map { |recipe_image| AttachmentUrlHelper.url_for(recipe_image.image) }.compact,
      category_ids: recipe.categories.order(:name).pluck(:id),
      categories: recipe.categories.order(:name).map do |category|
        {
          id: category.id,
          name: category.name
        }
      end,
      utensil_ids: recipe.utensil_ids,
      utensils: recipe.utensils.order(:name).map do |utensil|
        {
          id: utensil.id,
          name: utensil.name
        }
      end,
      created_at: recipe.created_at,
      updated_at: recipe.updated_at
    }
  end
end
