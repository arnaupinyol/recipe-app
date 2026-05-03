class StepImage < ApplicationRecord
  belongs_to :step, inverse_of: :step_images

  validates :url, presence: true
end
