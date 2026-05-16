class RecipeImage < ApplicationRecord
  has_one_attached :image

  belongs_to :recipe, inverse_of: :recipe_images

  validates :image, presence: true
end
