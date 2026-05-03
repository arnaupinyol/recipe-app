class ShoppingList < ApplicationRecord
  belongs_to :user, inverse_of: :shopping_lists

  has_many :shopping_list_items, dependent: :destroy, inverse_of: :shopping_list
  has_many :ingredients, through: :shopping_list_items

  validates :name, presence: true
end
