class AllergySerializer
  def self.render(allergy)
    {
      id: allergy.id,
      name: allergy.name,
      ingredient_ids: allergy.ingredient_ids,
      ingredients: allergy.ingredients.order(:name).map do |ingredient|
        {
          id: ingredient.id,
          name: ingredient.name
        }
      end,
      created_at: allergy.created_at,
      updated_at: allergy.updated_at
    }
  end
end
