class UtensilSerializer
  def self.render(utensil)
    {
      id: utensil.id,
      name: utensil.name,
      recipe_ids: utensil.recipe_ids,
      recipes: utensil.recipes.order(:title).map do |recipe|
        {
          id: recipe.id,
          title: recipe.title
        }
      end,
      created_at: utensil.created_at,
      updated_at: utensil.updated_at
    }
  end
end
