class Step < ApplicationRecord
  belongs_to :recipe, inverse_of: :steps

  has_many :step_images, dependent: :destroy, inverse_of: :step

  validates :order_number, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :recipe_id }
  validates :description, presence: true
  validates :timer_seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
