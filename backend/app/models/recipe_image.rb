class RecipeImage < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_images

  validates :url, presence: true
end
