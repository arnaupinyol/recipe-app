class RenameCatalanDomainToEnglish < ActiveRecord::Migration[8.1]
  def up
    rename_table_if_exists :alergies, :allergies
    rename_table_if_exists :alergies_usuaris, :allergies_users
    rename_table_if_exists :bloqueigs, :blocks
    rename_table_if_exists :categories_receptes, :categories_recipes
    rename_table_if_exists :comentaris, :comments
    rename_table_if_exists :estris, :utensils
    rename_table_if_exists :estris_receptes, :recipes_utensils
    rename_table_if_exists :imatges_pas, :step_images
    rename_table_if_exists :imatges_recepta, :recipe_images
    rename_table_if_exists :items_llista_compra, :shopping_list_items
    rename_table_if_exists :llistes_compra, :shopping_lists
    rename_table_if_exists :passos, :steps
    rename_table_if_exists :recepta_ingredients, :recipe_ingredients
    rename_table_if_exists :recepta_subreceptes, :recipe_subrecipes
    rename_table_if_exists :receptes, :recipes
    rename_table_if_exists :seguiments, :follows
    rename_table_if_exists :usuaris, :users
    rename_table_if_exists :usuaris_guarda_receptes, :user_saved_recipes
    rename_table_if_exists :usuaris_like_receptes, :user_recipe_likes

    rename_column_if_exists :allergies, :nom, :name
    rename_column_if_exists :allergies_ingredients, :alergia_id, :allergy_id
    rename_column_if_exists :allergies_users, :alergia_id, :allergy_id
    rename_column_if_exists :allergies_users, :usuari_id, :user_id
    rename_column_if_exists :blocks, :bloquejador_id, :blocker_id
    rename_column_if_exists :blocks, :bloquejat_id, :blocked_id
    rename_column_if_exists :blocks, :data_bloqueig, :blocked_at
    rename_column_if_exists :categories, :nom, :name
    rename_column_if_exists :categories, :descripcio, :description
    rename_column_if_exists :categories_recipes, :categoria_id, :category_id
    rename_column_if_exists :categories_recipes, :recepta_id, :recipe_id
    rename_column_if_exists :comments, :recepta_id, :recipe_id
    rename_column_if_exists :comments, :usuari_id, :user_id
    rename_column_if_exists :comments, :valoracio, :rating
    rename_column_if_exists :utensils, :nom, :name
    rename_column_if_exists :recipes_utensils, :estri_id, :utensil_id
    rename_column_if_exists :recipes_utensils, :recepta_id, :recipe_id
    rename_column_if_exists :step_images, :pas_id, :step_id
    rename_column_if_exists :recipe_images, :recepta_id, :recipe_id
    rename_column_if_exists :ingredients, :nom, :name
    rename_column_if_exists :ingredients, :descripcio_opcional, :optional_description
    rename_column_if_exists :ingredients, :foto_ingredient_url, :image_url
    rename_column_if_exists :shopping_list_items, :llista_compra_id, :shopping_list_id
    rename_column_if_exists :shopping_list_items, :quantitat, :quantity
    rename_column_if_exists :shopping_list_items, :tipus_racio, :unit_type
    rename_column_if_exists :shopping_list_items, :comprat, :purchased
    rename_column_if_exists :shopping_lists, :usuari_id, :user_id
    rename_column_if_exists :shopping_lists, :nom, :name
    rename_column_if_exists :shopping_lists, :descripcio_opcional, :optional_description
    rename_column_if_exists :steps, :recepta_id, :recipe_id
    rename_column_if_exists :steps, :numero_ordre, :order_number
    rename_column_if_exists :steps, :descripcio, :description
    rename_column_if_exists :steps, :temps_temporitzador_seg, :timer_seconds
    rename_column_if_exists :recipe_ingredients, :recepta_id, :recipe_id
    rename_column_if_exists :recipe_ingredients, :quantitat, :quantity
    rename_column_if_exists :recipe_ingredients, :tipus_racio, :unit_type
    rename_column_if_exists :recipe_ingredients, :observacions, :notes
    rename_column_if_exists :recipe_subrecipes, :recepta_id, :recipe_id
    rename_column_if_exists :recipe_subrecipes, :subrecepta_id, :subrecipe_id
    rename_column_if_exists :recipe_subrecipes, :quantitat, :quantity
    rename_column_if_exists :recipe_subrecipes, :tipus_racio, :unit_type
    rename_column_if_exists :recipe_subrecipes, :observacions, :notes
    rename_column_if_exists :recipes, :usuari_id, :user_id
    rename_column_if_exists :recipes, :titol, :title
    rename_column_if_exists :recipes, :descripcio, :description
    rename_column_if_exists :recipes, :visibilitat, :visibility
    rename_column_if_exists :recipes, :temps_preparacio, :preparation_time_minutes
    rename_column_if_exists :recipes, :dificultat, :difficulty
    rename_column_if_exists :recipes, :racions, :servings
    rename_column_if_exists :recipes, :likes, :likes_count
    rename_column_if_exists :recipes, :guardats, :saves_count
    rename_column_if_exists :recipes, :pot_ser_ingredient, :can_be_ingredient
    rename_column_if_exists :follows, :seguidor_id, :follower_id
    rename_column_if_exists :follows, :seguit_id, :followed_id
    rename_column_if_exists :follows, :data_seguiment, :followed_at
    rename_column_if_exists :users, :nom_usuari, :username
    rename_column_if_exists :users, :contrasenya_digest, :password_digest
    rename_column_if_exists :users, :biografia, :bio
    rename_column_if_exists :users, :foto_perfil_url, :profile_image_url
    rename_column_if_exists :users, :idioma, :language
    rename_column_if_exists :users, :privacitat, :private_profile
    rename_column_if_exists :users, :notificacions_actives, :notifications_enabled
    rename_column_if_exists :users, :estat_compte, :account_status
    rename_column_if_exists :users, :rol, :role
    rename_column_if_exists :user_saved_recipes, :usuari_id, :user_id
    rename_column_if_exists :user_saved_recipes, :recepta_id, :recipe_id
    rename_column_if_exists :user_recipe_likes, :usuari_id, :user_id
    rename_column_if_exists :user_recipe_likes, :recepta_id, :recipe_id

    rename_index_if_exists :allergies, "index_alergies_on_lower_nom", "index_allergies_on_lower_name"
    rename_index_if_exists :allergies_ingredients, "index_alergies_ingredients_on_ids", "index_allergies_ingredients_on_ids"
    rename_index_if_exists :allergies_ingredients, "index_alergies_ingredients_on_reverse_ids", "index_allergies_ingredients_on_reverse_ids"
    rename_index_if_exists :allergies_users, "index_alergies_usuaris_on_ids", "index_allergies_users_on_ids"
    rename_index_if_exists :allergies_users, "index_alergies_usuaris_on_reverse_ids", "index_allergies_users_on_reverse_ids"
    rename_index_if_exists :blocks, "index_bloqueigs_on_bloquejador_id_and_bloquejat_id", "index_blocks_on_blocker_id_and_blocked_id"
    rename_index_if_exists :blocks, "index_bloqueigs_on_bloquejador_id", "index_blocks_on_blocker_id"
    rename_index_if_exists :blocks, "index_bloqueigs_on_bloquejat_id", "index_blocks_on_blocked_id"
    rename_index_if_exists :categories, "index_categories_on_lower_nom", "index_categories_on_lower_name"
    rename_index_if_exists :categories_recipes, "index_categories_receptes_on_ids", "index_categories_recipes_on_ids"
    rename_index_if_exists :categories_recipes, "index_categories_receptes_on_reverse_ids", "index_categories_recipes_on_reverse_ids"
    rename_index_if_exists :comments, "index_comentaris_on_recepta_id", "index_comments_on_recipe_id"
    rename_index_if_exists :comments, "index_comentaris_on_usuari_id_and_recepta_id", "index_comments_on_user_id_and_recipe_id"
    rename_index_if_exists :comments, "index_comentaris_on_usuari_id", "index_comments_on_user_id"
    rename_index_if_exists :utensils, "index_estris_on_lower_nom", "index_utensils_on_lower_name"
    rename_index_if_exists :recipes_utensils, "index_estris_receptes_on_ids", "index_recipes_utensils_on_ids"
    rename_index_if_exists :recipes_utensils, "index_estris_receptes_on_reverse_ids", "index_recipes_utensils_on_reverse_ids"
    rename_index_if_exists :step_images, "index_imatges_pas_on_pas_id", "index_step_images_on_step_id"
    rename_index_if_exists :recipe_images, "index_imatges_recepta_on_recepta_id", "index_recipe_images_on_recipe_id"
    rename_index_if_exists :ingredients, "index_ingredients_on_lower_nom", "index_ingredients_on_lower_name"
    rename_index_if_exists :shopping_list_items, "index_items_llista_compra_on_ingredient_id", "index_shopping_list_items_on_ingredient_id"
    rename_index_if_exists :shopping_list_items, "index_items_llista_compra_on_llista_compra_id", "index_shopping_list_items_on_shopping_list_id"
    rename_index_if_exists :shopping_lists, "index_llistes_compra_on_usuari_id", "index_shopping_lists_on_user_id"
    rename_index_if_exists :steps, "index_passos_on_recepta_id_and_numero_ordre", "index_steps_on_recipe_id_and_order_number"
    rename_index_if_exists :steps, "index_passos_on_recepta_id", "index_steps_on_recipe_id"
    rename_index_if_exists :recipe_ingredients, "index_recepta_ingredients_on_ingredient_id", "index_recipe_ingredients_on_ingredient_id"
    rename_index_if_exists :recipe_ingredients, "index_recepta_ingredients_on_recepta_id_and_ingredient_id", "index_recipe_ingredients_on_recipe_id_and_ingredient_id"
    rename_index_if_exists :recipe_ingredients, "index_recepta_ingredients_on_recepta_id", "index_recipe_ingredients_on_recipe_id"
    rename_index_if_exists :recipe_subrecipes, "index_recepta_subreceptes_on_recepta_id_and_subrecepta_id", "index_recipe_subrecipes_on_recipe_id_and_subrecipe_id"
    rename_index_if_exists :recipe_subrecipes, "index_recepta_subreceptes_on_recepta_id", "index_recipe_subrecipes_on_recipe_id"
    rename_index_if_exists :recipe_subrecipes, "index_recepta_subreceptes_on_subrecepta_id", "index_recipe_subrecipes_on_subrecipe_id"
    rename_index_if_exists :recipes, "index_receptes_on_usuari_id", "index_recipes_on_user_id"
    rename_index_if_exists :recipes, "index_receptes_on_visibilitat", "index_recipes_on_visibility"
    rename_index_if_exists :follows, "index_seguiments_on_seguidor_id_and_seguit_id", "index_follows_on_follower_id_and_followed_id"
    rename_index_if_exists :follows, "index_seguiments_on_seguidor_id", "index_follows_on_follower_id"
    rename_index_if_exists :follows, "index_seguiments_on_seguit_id", "index_follows_on_followed_id"
    rename_index_if_exists :users, "index_usuaris_on_lower_email", "index_users_on_lower_email"
    rename_index_if_exists :users, "index_usuaris_on_lower_nom_usuari", "index_users_on_lower_username"
    rename_index_if_exists :user_saved_recipes, "index_usuaris_guarda_receptes_on_recepta_id", "index_user_saved_recipes_on_recipe_id"
    rename_index_if_exists :user_saved_recipes, "index_usuaris_guarda_receptes_on_usuari_id_and_recepta_id", "index_user_saved_recipes_on_user_id_and_recipe_id"
    rename_index_if_exists :user_saved_recipes, "index_usuaris_guarda_receptes_on_usuari_id", "index_user_saved_recipes_on_user_id"
    rename_index_if_exists :user_recipe_likes, "index_usuaris_like_receptes_on_recepta_id", "index_user_recipe_likes_on_recipe_id"
    rename_index_if_exists :user_recipe_likes, "index_usuaris_like_receptes_on_usuari_id_and_recepta_id", "index_user_recipe_likes_on_user_id_and_recipe_id"
    rename_index_if_exists :user_recipe_likes, "index_usuaris_like_receptes_on_usuari_id", "index_user_recipe_likes_on_user_id"
  end

  private

  def rename_table_if_exists(old_name, new_name)
    rename_table old_name, new_name if table_exists?(old_name)
  end

  def rename_column_if_exists(table_name, old_name, new_name)
    rename_column table_name, old_name, new_name if table_exists?(table_name) && column_exists?(table_name, old_name)
  end

  def rename_index_if_exists(table_name, old_name, new_name)
    rename_index table_name, old_name, new_name if table_exists?(table_name) && index_name_exists?(table_name, old_name)
  end
end
