# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_16_152000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "allergies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_allergies_on_lower_name", unique: true
  end

  create_table "allergies_ingredients", id: false, force: :cascade do |t|
    t.bigint "allergy_id", null: false
    t.bigint "ingredient_id", null: false
    t.index ["allergy_id", "ingredient_id"], name: "index_allergies_ingredients_on_ids", unique: true
    t.index ["ingredient_id", "allergy_id"], name: "index_allergies_ingredients_on_reverse_ids"
  end

  create_table "allergies_users", id: false, force: :cascade do |t|
    t.bigint "allergy_id", null: false
    t.bigint "user_id", null: false
    t.index ["allergy_id", "user_id"], name: "index_allergies_users_on_ids", unique: true
    t.index ["user_id", "allergy_id"], name: "index_allergies_users_on_reverse_ids"
  end

  create_table "blocks", force: :cascade do |t|
    t.datetime "blocked_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "blocked_id", null: false
    t.bigint "blocker_id", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_blocks_on_blocker_id_and_blocked_id", unique: true
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_categories_on_lower_name", unique: true
  end

  create_table "categories_recipes", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "recipe_id", null: false
    t.index ["category_id", "recipe_id"], name: "index_categories_recipes_on_ids", unique: true
    t.index ["recipe_id", "category_id"], name: "index_categories_recipes_on_reverse_ids"
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "rating", null: false
    t.bigint "recipe_id", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["recipe_id"], name: "index_comments_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_comments_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "followed_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "followed_id", null: false
    t.bigint "follower_id", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "optional_description"
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_ingredients_on_lower_name", unique: true
  end

  create_table "recipe_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_images_on_recipe_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "ingredient_id", null: false
    t.text "notes"
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.bigint "recipe_id", null: false
    t.integer "unit_type", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_subrecipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.bigint "recipe_id", null: false
    t.bigint "subrecipe_id", null: false
    t.integer "unit_type", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "subrecipe_id"], name: "index_recipe_subrecipes_on_recipe_id_and_subrecipe_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_subrecipes_on_recipe_id"
    t.index ["subrecipe_id"], name: "index_recipe_subrecipes_on_subrecipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.boolean "can_be_ingredient", default: false, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "difficulty", null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "preparation_time_minutes", null: false
    t.integer "saves_count", default: 0, null: false
    t.integer "servings", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "visibility", default: 0, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
    t.index ["visibility"], name: "index_recipes_on_visibility"
  end

  create_table "recipes_utensils", id: false, force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "utensil_id", null: false
    t.index ["recipe_id", "utensil_id"], name: "index_recipes_utensils_on_reverse_ids"
    t.index ["utensil_id", "recipe_id"], name: "index_recipes_utensils_on_ids", unique: true
  end

  create_table "revoked_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "jti", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_revoked_tokens_on_expires_at"
    t.index ["jti"], name: "index_revoked_tokens_on_jti", unique: true
  end

  create_table "shopping_list_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "ingredient_id", null: false
    t.boolean "purchased", default: false, null: false
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.bigint "shopping_list_id", null: false
    t.integer "unit_type", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_shopping_list_items_on_ingredient_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_items_on_shopping_list_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "optional_description"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_shopping_lists_on_user_id"
  end

  create_table "step_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "step_id", null: false
    t.datetime "updated_at", null: false
    t.index ["step_id"], name: "index_step_images_on_step_id"
  end

  create_table "steps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "order_number", null: false
    t.bigint "recipe_id", null: false
    t.integer "timer_seconds"
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "order_number"], name: "index_steps_on_recipe_id_and_order_number", unique: true
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "user_recipe_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["recipe_id"], name: "index_user_recipe_likes_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_user_recipe_likes_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_user_recipe_likes_on_user_id"
  end

  create_table "user_saved_recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["recipe_id"], name: "index_user_saved_recipes_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_user_saved_recipes_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_user_saved_recipes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "account_status", default: 0, null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "language", default: "ca", null: false
    t.boolean "notifications_enabled", default: true, null: false
    t.string "password_digest", null: false
    t.boolean "private_profile", default: false, null: false
    t.string "profile_image_url"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index "lower((username)::text)", name: "index_users_on_lower_username", unique: true
  end

  create_table "utensils", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_utensils_on_lower_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "allergies_ingredients", "allergies"
  add_foreign_key "allergies_ingredients", "ingredients"
  add_foreign_key "allergies_users", "allergies"
  add_foreign_key "allergies_users", "users"
  add_foreign_key "blocks", "users", column: "blocked_id"
  add_foreign_key "blocks", "users", column: "blocker_id"
  add_foreign_key "categories_recipes", "categories", column: "category_id"
  add_foreign_key "categories_recipes", "recipes"
  add_foreign_key "comments", "recipes"
  add_foreign_key "comments", "users"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "recipe_images", "recipes"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_subrecipes", "recipes"
  add_foreign_key "recipe_subrecipes", "recipes", column: "subrecipe_id"
  add_foreign_key "recipes", "users"
  add_foreign_key "recipes_utensils", "recipes"
  add_foreign_key "recipes_utensils", "utensils"
  add_foreign_key "shopping_list_items", "ingredients"
  add_foreign_key "shopping_list_items", "shopping_lists"
  add_foreign_key "shopping_lists", "users"
  add_foreign_key "step_images", "steps"
  add_foreign_key "steps", "recipes"
  add_foreign_key "user_recipe_likes", "recipes"
  add_foreign_key "user_recipe_likes", "users"
  add_foreign_key "user_saved_recipes", "recipes"
  add_foreign_key "user_saved_recipes", "users"
end
