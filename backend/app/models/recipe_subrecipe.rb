class RecipeSubrecipe < ApplicationRecord
  include HasUnitType

  belongs_to :recipe, inverse_of: :recipe_subrecipes
  belongs_to :subrecipe, class_name: "Recipe", inverse_of: :parent_recipe_relations

  validates :quantity, numericality: { greater_than: 0 }
  validates :subrecipe_id, uniqueness: { scope: :recipe_id }
  validate :subrecipe_must_be_different

  private

  def subrecipe_must_be_different
    return unless recipe_id.present? && recipe_id == subrecipe_id

    errors.add(:subrecipe_id, "must be a different recipe")
  end
end
