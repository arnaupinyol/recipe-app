class Comment < ApplicationRecord
  belongs_to :recipe, inverse_of: :comments
  belongs_to :user, inverse_of: :comments

  validates :text, presence: true
  validates :rating, inclusion: { in: 1..10 }
  validates :user_id, uniqueness: { scope: :recipe_id }
end
