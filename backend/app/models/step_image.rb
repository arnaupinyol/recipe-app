class StepImage < ApplicationRecord
  has_one_attached :image

  belongs_to :step, inverse_of: :step_images

  validates :image, presence: true
end
