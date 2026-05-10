require "test_helper"

class RecipesTest < ActionDispatch::IntegrationTest
  test "lists only visible recipes for anonymous users" do
    user_1 = create_user(username: "recipe_owner_1", email: "recipe.owner.1@example.com")
    user_2 = create_user(username: "recipe_owner_2", email: "recipe.owner.2@example.com")

    create_recipe_for(user: user_1, title: "Soup")
    create_recipe_for(user: user_2, title: "Secret Cake", visibility: :private_recipe)

    get "/api/recipes"

    assert_response :success

    assert_equal [ "Soup" ], response_json["recipes"].map { |recipe| recipe["title"] }
  end

  test "shows a public recipe" do
    user = create_user(username: "recipe_show_owner", email: "recipe.show.owner@example.com")
    category = Category.create!(name: "Desserts")
    utensil = Utensil.create!(name: "Oven")
    recipe = create_recipe_for(user: user, title: "Bread", description: "Crusty", preparation_time_minutes: 60, difficulty: 4, servings: 4)
    recipe.categories << category
    recipe.utensils << utensil

    get "/api/recipes/#{recipe.id}"

    assert_response :success

    assert_equal "Bread", response_json.dig("recipe", "title")
    assert_equal [ "Desserts" ], response_json.dig("recipe", "categories").map { |item| item["name"] }
    assert_equal [ "Oven" ], response_json.dig("recipe", "utensils").map { |item| item["name"] }
  end

  test "hides a private recipe from anonymous users" do
    user = create_user(username: "private_recipe_owner", email: "private.recipe.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Hidden", visibility: :private_recipe)

    get "/api/recipes/#{recipe.id}"

    assert_response :not_found
    assert_equal "Recipe not found", response_json.dig("error", "message")
  end

  test "shows a private recipe to its owner" do
    user = create_user(username: "private_recipe_auth", email: "private.recipe.auth@example.com")
    recipe = create_recipe_for(user: user, title: "Owner Secret", visibility: :private_recipe)

    get "/api/recipes/#{recipe.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Owner Secret", response_json.dig("recipe", "title")
  end

  test "creates a recipe for the authenticated user" do
    user = create_user(username: "recipe_create_owner", email: "recipe.create.owner@example.com")
    category = Category.create!(name: "Main")
    utensil = Utensil.create!(name: "Pan")

    post "/api/recipes", params: {
      recipe: {
        user_id: 999999,
        title: "Rice",
        description: "Tasty",
        preparation_time_minutes: 25,
        difficulty: 2,
        servings: 3,
        visibility: "public_recipe",
        can_be_ingredient: false,
        category_ids: [ category.id ],
        utensil_ids: [ utensil.id ]
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created

    assert_equal "Rice", response_json.dig("recipe", "title")
    assert_equal user.id, response_json.dig("recipe", "user_id")
    assert_equal [ category.id ], response_json.dig("recipe", "category_ids")
    assert_equal [ utensil.id ], response_json.dig("recipe", "utensil_ids")
  end

  test "rejects recipe creation without authentication" do
    post "/api/recipes", params: {
      recipe: {
        title: "Rice",
        preparation_time_minutes: 25,
        difficulty: 2,
        servings: 3
      }
    }, as: :json

    assert_response :unauthorized
    assert_equal "Unauthorized", response_json.dig("error", "message")
  end

  test "updates a recipe only for its owner" do
    user = create_user(username: "recipe_update_owner", email: "recipe.update.owner@example.com")
    category = Category.create!(name: "Healthy")
    utensil = Utensil.create!(name: "Pot")
    recipe = create_recipe_for(user: user, title: "Tea", description: "Simple", preparation_time_minutes: 5, difficulty: 1, servings: 1)

    patch "/api/recipes/#{recipe.id}", params: {
      recipe: {
        description: "Very simple",
        category_ids: [ category.id ],
        utensil_ids: [ utensil.id ]
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success

    assert_equal "Very simple", response_json.dig("recipe", "description")
    assert_equal [ category.id ], response_json.dig("recipe", "category_ids")
    assert_equal [ utensil.id ], response_json.dig("recipe", "utensil_ids")
  end

  test "prevents updating another user's recipe" do
    owner = create_user(username: "recipe_owner", email: "recipe.owner@example.com")
    intruder = create_user(username: "recipe_intruder", email: "recipe.intruder@example.com")
    recipe = create_recipe_for(user: owner, title: "Protected")

    patch "/api/recipes/#{recipe.id}", params: {
      recipe: {
        description: "Changed"
      }
    }, headers: auth_headers_for(intruder), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "deletes a recipe" do
    user = create_user(username: "recipe_delete_owner", email: "recipe.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Salad", description: "Fresh", preparation_time_minutes: 10, difficulty: 1, servings: 2)

    delete "/api/recipes/#{recipe.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Recipe deleted", response_json["message"]
    assert_not Recipe.exists?(recipe.id)
  end

  test "returns not found for a missing recipe" do
    get "/api/recipes/999999"

    assert_response :not_found
    assert_equal "Recipe not found", response_json.dig("error", "message")
  end

  test "returns validation errors when recipe is invalid" do
    user = create_user(username: "recipe_invalid_owner", email: "recipe.invalid.owner@example.com")

    post "/api/recipes", params: {
      recipe: {
        title: "",
        preparation_time_minutes: -1,
        difficulty: 8,
        servings: 0
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Recipe creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "title").present?
    assert response_json.dig("error", "details", "difficulty").present?
  end

  test "returns validation errors when recipe relations are invalid" do
    user = create_user(username: "recipe_invalid_rel", email: "recipe.invalid.rel@example.com")

    post "/api/recipes", params: {
      recipe: {
        title: "Ghost",
        preparation_time_minutes: 10,
        difficulty: 2,
        servings: 2,
        category_ids: [ 999998 ],
        utensil_ids: [ 999997 ]
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Recipe creation failed", response_json.dig("error", "message")
    assert_equal [ "contain invalid values" ], response_json.dig("error", "details", "category_ids")
    assert_equal [ "contain invalid values" ], response_json.dig("error", "details", "utensil_ids")
  end
end
