require "test_helper"

class RecipesTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "lists recipes" do
    user_1 = create_user(username: "recipe_owner_1", email: "recipe.owner.1@example.com")
    user_2 = create_user(username: "recipe_owner_2", email: "recipe.owner.2@example.com")

    Recipe.create!(user: user_1, title: "Soup", description: "Warm", preparation_time_minutes: 20, difficulty: 2, servings: 2)
    Recipe.create!(user: user_2, title: "Cake", description: "Sweet", preparation_time_minutes: 45, difficulty: 3, servings: 8)

    get "/api/recipes"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["recipes"].length
  end

  test "shows a recipe" do
    user = create_user(username: "recipe_show_owner", email: "recipe.show.owner@example.com")
    category = Category.create!(name: "Desserts")
    utensil = Utensil.create!(name: "Oven")
    recipe = Recipe.create!(
      user: user,
      title: "Bread",
      description: "Crusty",
      preparation_time_minutes: 60,
      difficulty: 4,
      servings: 4
    )
    recipe.categories << category
    recipe.utensils << utensil

    get "/api/recipes/#{recipe.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bread", response_body.dig("recipe", "title")
    assert_equal [ "Desserts" ], response_body.dig("recipe", "categories").map { |item| item["name"] }
    assert_equal [ "Oven" ], response_body.dig("recipe", "utensils").map { |item| item["name"] }
  end

  test "creates a recipe" do
    user = create_user(username: "recipe_create_owner", email: "recipe.create.owner@example.com")
    category = Category.create!(name: "Main")
    utensil = Utensil.create!(name: "Pan")

    post "/api/recipes", params: {
      recipe: {
        user_id: user.id,
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
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Rice", response_body.dig("recipe", "title")
    assert_equal [ category.id ], response_body.dig("recipe", "category_ids")
    assert_equal [ utensil.id ], response_body.dig("recipe", "utensil_ids")
  end

  test "updates a recipe" do
    user = create_user(username: "recipe_update_owner", email: "recipe.update.owner@example.com")
    category = Category.create!(name: "Healthy")
    utensil = Utensil.create!(name: "Pot")
    recipe = Recipe.create!(
      user: user,
      title: "Tea",
      description: "Simple",
      preparation_time_minutes: 5,
      difficulty: 1,
      servings: 1
    )

    patch "/api/recipes/#{recipe.id}", params: {
      recipe: {
        description: "Very simple",
        category_ids: [ category.id ],
        utensil_ids: [ utensil.id ]
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Very simple", response_body.dig("recipe", "description")
    assert_equal [ category.id ], response_body.dig("recipe", "category_ids")
    assert_equal [ utensil.id ], response_body.dig("recipe", "utensil_ids")
  end

  test "deletes a recipe" do
    user = create_user(username: "recipe_delete_owner", email: "recipe.delete.owner@example.com")
    recipe = Recipe.create!(
      user: user,
      title: "Salad",
      description: "Fresh",
      preparation_time_minutes: 10,
      difficulty: 1,
      servings: 2
    )

    delete "/api/recipes/#{recipe.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Recipe deleted", response_body["message"]
    assert_not Recipe.exists?(recipe.id)
  end

  test "returns not found for a missing recipe" do
    get "/api/recipes/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Recipe not found", response_body.dig("error", "message")
  end

  test "returns validation errors when recipe is invalid" do
    user = create_user(username: "recipe_invalid_owner", email: "recipe.invalid.owner@example.com")

    post "/api/recipes", params: {
      recipe: {
        user_id: user.id,
        title: "",
        preparation_time_minutes: -1,
        difficulty: 8,
        servings: 0
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "title").present?
    assert response_body.dig("error", "details", "difficulty").present?
  end

  test "returns validation errors when recipe relations are invalid" do
    post "/api/recipes", params: {
      recipe: {
        user_id: 999999,
        title: "Ghost",
        preparation_time_minutes: 10,
        difficulty: 2,
        servings: 2,
        category_ids: [ 999998 ],
        utensil_ids: [ 999997 ]
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "user_id")
    assert_equal [ "contain invalid values" ], response_body.dig("error", "details", "category_ids")
    assert_equal [ "contain invalid values" ], response_body.dig("error", "details", "utensil_ids")
  end
end
