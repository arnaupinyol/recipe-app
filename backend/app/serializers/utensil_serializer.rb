class UtensilSerializer
  def self.render(utensil, recipes: nil)
    visible_recipes = recipes || utensil.recipes.order(:title)

    {
      id: utensil.id,
      name: utensil.name,
      recipe_ids: visible_recipes.map(&:id),
      recipes: visible_recipes.map do |recipe|
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
