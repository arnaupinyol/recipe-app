require "test_helper"

class RecipeIngredientsTest < ActionDispatch::IntegrationTest
  def create_recipe_for(username:, email:, title:)
    user = User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )

    Recipe.create!(
      user: user,
      title: title,
      description: "Recipe description",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 2
    )
  end

  test "lists recipe ingredients" do
    recipe_1 = create_recipe_for(username: "ri_owner_1", email: "ri.owner.1@example.com", title: "Soup")
    recipe_2 = create_recipe_for(username: "ri_owner_2", email: "ri.owner.2@example.com", title: "Cake")
    ingredient_1 = Ingredient.create!(name: "Salt")
    ingredient_2 = Ingredient.create!(name: "Sugar")

    RecipeIngredient.create!(recipe: recipe_1, ingredient: ingredient_1, quantity: 5, unit_type: :grams)
    RecipeIngredient.create!(recipe: recipe_2, ingredient: ingredient_2, quantity: 100, unit_type: :grams)

    get "/api/recipe_ingredients"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["recipe_ingredients"].length
  end

  test "shows a recipe ingredient" do
    recipe = create_recipe_for(username: "ri_show_owner", email: "ri.show.owner@example.com", title: "Bread")
    ingredient = Ingredient.create!(name: "Flour")
    recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 500, unit_type: :grams)

    get "/api/recipe_ingredients/#{recipe_ingredient.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bread", response_body.dig("recipe_ingredient", "recipe_title")
    assert_equal "Flour", response_body.dig("recipe_ingredient", "ingredient_name")
  end

  test "creates a recipe ingredient" do
    recipe = create_recipe_for(username: "ri_create_owner", email: "ri.create.owner@example.com", title: "Pizza")
    ingredient = Ingredient.create!(name: "Cheese")

    post "/api/recipe_ingredients", params: {
      recipe_ingredient: {
        recipe_id: recipe.id,
        ingredient_id: ingredient.id,
        quantity: 150,
        unit_type: "grams",
        notes: "Grated"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal recipe.id, response_body.dig("recipe_ingredient", "recipe_id")
    assert_equal ingredient.id, response_body.dig("recipe_ingredient", "ingredient_id")
  end

  test "updates a recipe ingredient" do
    recipe = create_recipe_for(username: "ri_update_owner", email: "ri.update.owner@example.com", title: "Rice")
    ingredient = Ingredient.create!(name: "Butter")
    recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 10, unit_type: :grams)

    patch "/api/recipe_ingredients/#{recipe_ingredient.id}", params: {
      recipe_ingredient: {
        quantity: 20,
        notes: "Unsalted"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Unsalted", response_body.dig("recipe_ingredient", "notes")
    assert_equal 20, response_body.dig("recipe_ingredient", "quantity").to_i
  end

  test "deletes a recipe ingredient" do
    recipe = create_recipe_for(username: "ri_delete_owner", email: "ri.delete.owner@example.com", title: "Tea")
    ingredient = Ingredient.create!(name: "Honey")
    recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 1, unit_type: :units)

    delete "/api/recipe_ingredients/#{recipe_ingredient.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Recipe ingredient deleted", response_body["message"]
    assert_not RecipeIngredient.exists?(recipe_ingredient.id)
  end

  test "returns not found for a missing recipe ingredient" do
    get "/api/recipe_ingredients/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Recipe ingredient not found", response_body.dig("error", "message")
  end

  test "returns validation errors when recipe ingredient is invalid" do
    recipe = create_recipe_for(username: "ri_invalid_owner", email: "ri.invalid.owner@example.com", title: "Pasta")
    ingredient = Ingredient.create!(name: "Oil")

    post "/api/recipe_ingredients", params: {
      recipe_ingredient: {
        recipe_id: recipe.id,
        ingredient_id: ingredient.id,
        quantity: 0,
        unit_type: "grams"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe ingredient creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "quantity").present?
  end

  test "returns validation errors when recipe ingredient relations are invalid" do
    post "/api/recipe_ingredients", params: {
      recipe_ingredient: {
        recipe_id: 999999,
        ingredient_id: 999998,
        quantity: 1,
        unit_type: "units"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe ingredient creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "recipe_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "ingredient_id")
  end
end
