class RecipeSubrecipeSerializer
  def self.render(recipe_subrecipe)
    {
      id: recipe_subrecipe.id,
      recipe_id: recipe_subrecipe.recipe_id,
      recipe_title: recipe_subrecipe.recipe.title,
      subrecipe_id: recipe_subrecipe.subrecipe_id,
      subrecipe_title: recipe_subrecipe.subrecipe.title,
      quantity: recipe_subrecipe.quantity,
      unit_type: recipe_subrecipe.unit_type,
      notes: recipe_subrecipe.notes,
      created_at: recipe_subrecipe.created_at,
      updated_at: recipe_subrecipe.updated_at
    }
  end
end
