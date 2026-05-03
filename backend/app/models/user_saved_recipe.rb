class UserSavedRecipe < ApplicationRecord
  belongs_to :recipe, counter_cache: :saves_count, inverse_of: :user_saved_recipes
  belongs_to :user, inverse_of: :user_saved_recipes

  validates :user_id, uniqueness: { scope: :recipe_id }
end
