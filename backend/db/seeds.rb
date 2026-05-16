# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# db/seeds.rb

puts "Iniciant càrrega de seeds..."

def seed_user
  user = User.find_or_initialize_by(email: "demo@receptari.local")
  user.assign_attributes(
    username: "receptari_demo",
    password: "password123",
    password_confirmation: "password123",
    role: :admin,
    account_status: :active,
    language: "ca",
    bio: "Usuari de sistema per a receptes i dades base."
  )
  user.save!
  user
end

def attach_seed_image(record, attachment_name, relative_path, filename: nil, content_type: nil)
  path = Rails.root.join("db/seed_images", relative_path)

  unless File.exist?(path)
    puts "Imatge no trobada: #{path}"
    return
  end

  attachment = record.public_send(attachment_name)

  return if attachment.attached?

  attachment.attach(
    io: File.open(path, "rb"),
    filename: filename || File.basename(path),
    content_type: content_type || Rack::Mime.mime_type(path.extname, "application/octet-stream")
  )

  record.save! if record.new_record?
end

def find_by_names!(klass, names)
  records = klass.where(name: names).to_a
  missing_names = names - records.map(&:name)
  raise ActiveRecord::RecordNotFound, "#{klass.name} not found: #{missing_names.join(', ')}" if missing_names.any?

  records
end

def sync_recipe_categories(recipe, category_names)
  recipe.categories = find_by_names!(Category, category_names)
end

def sync_recipe_utensils(recipe, utensil_names)
  recipe.utensils = find_by_names!(Utensil, utensil_names)
end

def sync_recipe_ingredients(recipe, ingredients)
  keep_ids = []

  ingredients.each do |data|
    ingredient = Ingredient.find_by!(name: data[:name])
    recipe_ingredient = RecipeIngredient.find_or_initialize_by(recipe: recipe, ingredient: ingredient)
    recipe_ingredient.assign_attributes(
      quantity: data[:quantity],
      unit_type: data[:unit_type],
      notes: data[:notes]
    )
    recipe_ingredient.save!
    keep_ids << recipe_ingredient.id
  end

  recipe.recipe_ingredients.where.not(id: keep_ids).destroy_all
end

def sync_recipe_subrecipes(recipe, subrecipes)
  keep_ids = []

  subrecipes.each do |data|
    subrecipe = Recipe.find_by!(title: data[:title])
    relation = RecipeSubrecipe.find_or_initialize_by(recipe: recipe, subrecipe: subrecipe)
    relation.assign_attributes(
      quantity: data[:quantity],
      unit_type: data[:unit_type],
      notes: data[:notes]
    )
    relation.save!
    keep_ids << relation.id
  end

  recipe.recipe_subrecipes.where.not(id: keep_ids).destroy_all
end

def sync_recipe_steps(recipe, steps)
  keep_ids = []

  steps.each_with_index do |description, index|
    step = Step.find_or_initialize_by(recipe: recipe, order_number: index + 1)
    step.assign_attributes(description: description)
    step.save!
    keep_ids << step.id
  end

  recipe.steps.where.not(id: keep_ids).destroy_all
end

def upsert_seed_recipe(data)
  recipe = Recipe.find_or_initialize_by(title: data[:title])
  recipe.assign_attributes(
    user: seed_user,
    description: data[:description],
    preparation_time_minutes: data[:preparation_time_minutes],
    difficulty: data[:difficulty],
    servings: data[:servings],
    visibility: data.fetch(:visibility, :public_recipe),
    can_be_ingredient: data.fetch(:can_be_ingredient, false)
  )
  recipe.save!

  sync_recipe_categories(recipe, data.fetch(:categories, []))
  sync_recipe_utensils(recipe, data.fetch(:utensils, []))
  sync_recipe_ingredients(recipe, data.fetch(:ingredients, []))
  sync_recipe_subrecipes(recipe, data.fetch(:subrecipes, []))
  sync_recipe_steps(recipe, data.fetch(:steps, []))
  if data[:image].present?
    recipe_image = recipe.recipe_images.first || recipe.recipe_images.build
    attach_seed_image(recipe_image, :image, data[:image])
  end

  recipe
end

load Rails.root.join("db/seeds/categories.rb")
load Rails.root.join("db/seeds/ingredients.rb")
load Rails.root.join("db/seeds/utensils.rb")
load Rails.root.join("db/seeds/base_recipes.rb")
load Rails.root.join("db/seeds/normal_recipes.rb")

puts "Seeds carregats correctament."
