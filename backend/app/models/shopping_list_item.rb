class ShoppingListItem < ApplicationRecord
  include HasUnitType

  belongs_to :ingredient, inverse_of: :shopping_list_items
  belongs_to :shopping_list, inverse_of: :shopping_list_items

  validates :quantity, numericality: { greater_than: 0 }
end
