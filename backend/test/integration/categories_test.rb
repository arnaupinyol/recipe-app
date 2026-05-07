require "test_helper"

class CategoriesTest < ActionDispatch::IntegrationTest
  test "lists categories" do
    Category.create!(name: "Postres", description: "Dolcos i pastissos")
    Category.create!(name: "Amanides", description: "Opcions fresques")

    get "/api/categories"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ "Amanides", "Postres" ], response_body["categories"].map { |category| category["name"] }
  end

  test "shows a category" do
    category = Category.create!(name: "Sopes", description: "Per dies freds")

    get "/api/categories/#{category.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Sopes", response_body.dig("category", "name")
    assert_equal "Per dies freds", response_body.dig("category", "description")
  end

  test "creates a category" do
    post "/api/categories", params: {
      category: {
        name: "Esmorzars",
        description: "Per començar el dia"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Esmorzars", response_body.dig("category", "name")
    assert_equal "Per començar el dia", response_body.dig("category", "description")
  end

  test "updates a category" do
    category = Category.create!(name: "Begudes", description: "Fredes")

    patch "/api/categories/#{category.id}", params: {
      category: {
        description: "Fredes i calentes"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Fredes i calentes", response_body.dig("category", "description")
    assert_equal "Fredes i calentes", category.reload.description
  end

  test "deletes a category without recipes" do
    category = Category.create!(name: "Temporada", description: "Productes del moment")

    delete "/api/categories/#{category.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Category deleted", response_body["message"]
    assert_not Category.exists?(category.id)
  end

  test "does not delete a category associated with recipes" do
    user = User.create!(
      username: "category_owner",
      email: "category.owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    category = Category.create!(name: "Pasta")
    recipe = Recipe.create!(
      user: user,
      title: "Macarrons",
      description: "Classics",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 4
    )
    recipe.categories << category

    delete "/api/categories/#{category.id}"

    assert_response :conflict

    response_body = JSON.parse(response.body)
    assert_equal "Category cannot be deleted because it is associated with recipes", response_body.dig("error", "message")
    assert Category.exists?(category.id)
  end

  test "returns not found for a missing category" do
    get "/api/categories/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Category not found", response_body.dig("error", "message")
  end

  test "returns validation errors when category is invalid" do
    post "/api/categories", params: {
      category: {
        name: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Category creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "name").present?
  end
end
