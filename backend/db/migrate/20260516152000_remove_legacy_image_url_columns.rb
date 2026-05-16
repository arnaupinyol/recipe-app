class RemoveLegacyImageUrlColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :ingredients, :image_url, :string if column_exists?(:ingredients, :image_url)
    remove_column :recipe_images, :url, :string if column_exists?(:recipe_images, :url)
    remove_column :step_images, :url, :string if column_exists?(:step_images, :url)
  end
end
