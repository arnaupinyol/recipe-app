class Ingredient < ApplicationRecord
  has_and_belongs_to_many :allergies

  has_many :shopping_list_items, dependent: :restrict_with_exception, inverse_of: :ingredient
  has_many :shopping_lists, through: :shopping_list_items
  has_many :recipe_ingredients, dependent: :restrict_with_exception, inverse_of: :ingredient
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
