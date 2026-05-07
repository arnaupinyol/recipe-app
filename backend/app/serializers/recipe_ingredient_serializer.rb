class RecipeIngredientSerializer
  def self.render(recipe_ingredient)
    {
      id: recipe_ingredient.id,
      recipe_id: recipe_ingredient.recipe_id,
      recipe_title: recipe_ingredient.recipe.title,
      ingredient_id: recipe_ingredient.ingredient_id,
      ingredient_name: recipe_ingredient.ingredient.name,
      quantity: recipe_ingredient.quantity,
      unit_type: recipe_ingredient.unit_type,
      notes: recipe_ingredient.notes,
      created_at: recipe_ingredient.created_at,
      updated_at: recipe_ingredient.updated_at
    }
  end
end
