class Category < ApplicationRecord
  has_one_attached :image

  has_and_belongs_to_many :recipes, join_table: :categories_recipes

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
