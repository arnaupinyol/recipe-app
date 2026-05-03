class FixAllergiesIngredientsRename < ActiveRecord::Migration[8.1]
  def up
    return unless table_exists?(:alergies_ingredients)

    rename_table :alergies_ingredients, :allergies_ingredients
    rename_column :allergies_ingredients, :alergia_id, :allergy_id if column_exists?(:allergies_ingredients, :alergia_id)
    rename_index :allergies_ingredients, "index_alergies_ingredients_on_ids", "index_allergies_ingredients_on_ids" if index_name_exists?(:allergies_ingredients, "index_alergies_ingredients_on_ids")
    rename_index :allergies_ingredients, "index_alergies_ingredients_on_reverse_ids", "index_allergies_ingredients_on_reverse_ids" if index_name_exists?(:allergies_ingredients, "index_alergies_ingredients_on_reverse_ids")
  end
end
