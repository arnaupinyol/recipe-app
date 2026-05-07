class RecipeImageSerializer
  def self.render(recipe_image)
    {
      id: recipe_image.id,
      recipe_id: recipe_image.recipe_id,
      recipe_title: recipe_image.recipe.title,
      url: recipe_image.url,
      created_at: recipe_image.created_at,
      updated_at: recipe_image.updated_at
    }
  end
end
