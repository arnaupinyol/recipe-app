class Recipe < ApplicationRecord
  belongs_to :user, inverse_of: :recipes

  has_and_belongs_to_many :categories, join_table: :categories_recipes
  has_and_belongs_to_many :utensils, join_table: :recipes_utensils

  has_many :comments, dependent: :destroy, inverse_of: :recipe
  has_many :recipe_images, dependent: :destroy, inverse_of: :recipe
  has_many :steps, dependent: :destroy, inverse_of: :recipe
  has_many :recipe_ingredients, dependent: :destroy, inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_subrecipes, foreign_key: :recipe_id, dependent: :destroy, inverse_of: :recipe
  has_many :subrecipes, through: :recipe_subrecipes, source: :subrecipe
  has_many :parent_recipe_relations, class_name: "RecipeSubrecipe", foreign_key: :subrecipe_id, dependent: :destroy,
                                     inverse_of: :subrecipe
  has_many :parent_recipes, through: :parent_recipe_relations, source: :recipe
  has_many :user_saved_recipes, dependent: :destroy, inverse_of: :recipe
  has_many :savers, through: :user_saved_recipes, source: :user
  has_many :user_recipe_likes, dependent: :destroy, inverse_of: :recipe
  has_many :likers, through: :user_recipe_likes, source: :user

  enum :visibility, { public_recipe: 0, private_recipe: 1 }

  validates :title, presence: true, length: { maximum: 150 }
  validates :preparation_time_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :difficulty, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :servings, numericality: { only_integer: true, greater_than: 0 }
  validates :likes_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :saves_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
