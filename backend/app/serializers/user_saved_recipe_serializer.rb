class UserSavedRecipeSerializer
  def self.render(saved_recipe)
    {
      id: saved_recipe.id,
      user_id: saved_recipe.user_id,
      username: saved_recipe.user.username,
      recipe_id: saved_recipe.recipe_id,
      recipe_title: saved_recipe.recipe.title,
      created_at: saved_recipe.created_at,
      updated_at: saved_recipe.updated_at
    }
  end
end
