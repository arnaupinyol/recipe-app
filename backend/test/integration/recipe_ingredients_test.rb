require "test_helper"

class RecipeIngredientsTest < ActionDispatch::IntegrationTest
  test "lists recipe ingredients only for visible recipes" do
    owner = create_user(username: "ri_owner_1", email: "ri.owner.1@example.com")
    other_owner = create_user(username: "ri_owner_2", email: "ri.owner.2@example.com")
    recipe_1 = create_recipe_for(user: owner, title: "Soup")
    recipe_2 = create_recipe_for(user: other_owner, title: "Cake", visibility: :private_recipe)
    ingredient_1 = Ingredient.create!(name: "Salt")
    ingredient_2 = Ingredient.create!(name: "Sugar")

    RecipeIngredient.create!(recipe: recipe_1, ingredient: ingredient_1, quantity: 5, unit_type: :grams)
    RecipeIngredient.create!(recipe: recipe_2, ingredient: ingredient_2, quantity: 100, unit_type: :grams)

    get "/api/recipe_ingredients"

    assert_response :success
    assert_equal 1, response_json["recipe_ingredients"].length
  end

  test "shows a recipe ingredient" do
    user = create_user(username: "ri_show_owner", email: "ri.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    ingredient = Ingredient.create!(name: "Flour")
    recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 500, unit_type: :grams)

    get "/api/recipe_ingredients/#{recipe_ingredient.id}"

    assert_response :success
    assert_equal "Bread", response_json.dig("recipe_ingredient", "recipe_title")
    assert_equal "Flour", response_json.dig("recipe_ingredient", "ingredient_name")
  end

  test "creates a recipe ingredient only for an owned recipe" do
    user = create_user(username: "ri_create_owner", email: "ri.create.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pizza")
    ingredient = Ingredient.create!(name: "Cheese")

    post "/api/recipe_ingredients", params: {
      recipe_ingredient: {
        recipe_id: recipe.id,
        ingredient_id: ingredient.id,
        quantity: 150,
        unit_type: "grams",
        notes: "Grated"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created
    assert_equal recipe.id, response_json.dig("recipe_ingredient", "recipe_id")
    assert_equal ingredient.id, response_json.dig("recipe_ingredient", "ingredient_id")
  end

  test "updates a recipe ingredient only for its owner" do
    user = create_user(username: "ri_update_owner", email: "ri.update.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Rice")
    ingredient = Ingredient.create!(name: "Butter")
    recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 10, unit_type: :grams)

    patch "/api/recipe_ingredients/#{recipe_ingredient.id}", params: {
      recipe_ingredient: {
        quantity: 20,
        notes: "Unsalted"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success
    assert_equal "Unsalted", response_json.dig("recipe_ingredient", "notes")
    assert_equal 20, response_json.dig("recipe_ingredient", "quantity").to_i
  end

  test "deletes a recipe ingredient" do
    user = create_user(username: "ri_delete_owner", email: "ri.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Tea")
    ingredient = Ingredient.create!(name: "Honey")
    recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 1, unit_type: :units)

    delete "/api/recipe_ingredients/#{recipe_ingredient.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Recipe ingredient deleted", response_json["message"]
    assert_not RecipeIngredient.exists?(recipe_ingredient.id)
  end

  test "returns validation errors when recipe id is not editable" do
    user = create_user(username: "ri_intruder", email: "ri.intruder@example.com")
    owner = create_user(username: "ri_real_owner", email: "ri.real.owner@example.com")
    recipe = create_recipe_for(user: owner, title: "Locked")
    ingredient = Ingredient.create!(name: "Oil")

    post "/api/recipe_ingredients", params: {
      recipe_ingredient: {
        recipe_id: recipe.id,
        ingredient_id: ingredient.id,
        quantity: 1,
        unit_type: "units"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "recipe_id")
  end
end
