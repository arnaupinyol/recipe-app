class UserRecipeLike < ApplicationRecord
  belongs_to :recipe, counter_cache: :likes_count, inverse_of: :user_recipe_likes
  belongs_to :user, inverse_of: :user_recipe_likes

  validates :user_id, uniqueness: { scope: :recipe_id }
end
