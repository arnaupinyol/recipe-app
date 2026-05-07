class RecipeSerializer
  def self.render(recipe)
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
