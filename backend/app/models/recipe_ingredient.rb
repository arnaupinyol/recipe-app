class RecipeIngredient < ApplicationRecord
  include HasUnitType

  belongs_to :ingredient, inverse_of: :recipe_ingredients
  belongs_to :recipe, inverse_of: :recipe_ingredients

  validates :quantity, numericality: { greater_than: 0 }
  validates :ingredient_id, uniqueness: { scope: :recipe_id }
end
