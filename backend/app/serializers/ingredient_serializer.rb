class IngredientSerializer
  def self.render(ingredient)
    {
      id: ingredient.id,
      name: ingredient.name,
      image_url: ingredient.image_url,
      optional_description: ingredient.optional_description,
      allergy_ids: ingredient.allergy_ids,
      allergies: ingredient.allergies.order(:name).map do |allergy|
        {
          id: allergy.id,
          name: allergy.name
        }
      end,
      created_at: ingredient.created_at,
      updated_at: ingredient.updated_at
    }
  end
end
