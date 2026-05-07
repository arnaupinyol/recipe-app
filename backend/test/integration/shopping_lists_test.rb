require "test_helper"

class ShoppingListsTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "lists shopping lists" do
    user_1 = create_user(username: "shopping_owner_1", email: "shopping.owner.1@example.com")
    user_2 = create_user(username: "shopping_owner_2", email: "shopping.owner.2@example.com")

    ShoppingList.create!(user: user_1, name: "Setmana", optional_description: "Compra principal")
    ShoppingList.create!(user: user_2, name: "Cap de setmana", optional_description: "Extra")

    get "/api/shopping_lists"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ "Cap de setmana", "Setmana" ], response_body["shopping_lists"].map { |shopping_list| shopping_list["name"] }
  end

  test "shows a shopping list" do
    user = create_user(username: "shopping_show_owner", email: "shopping.show.owner@example.com")
    shopping_list = ShoppingList.create!(user: user, name: "Mercat", optional_description: "Dissabte")

    get "/api/shopping_lists/#{shopping_list.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Mercat", response_body.dig("shopping_list", "name")
    assert_equal user.username, response_body.dig("shopping_list", "username")
  end

  test "creates a shopping list" do
    user = create_user(username: "shopping_create_owner", email: "shopping.create.owner@example.com")

    post "/api/shopping_lists", params: {
      shopping_list: {
        name: "Fruita",
        optional_description: "Per tota la setmana",
        user_id: user.id
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Fruita", response_body.dig("shopping_list", "name")
    assert_equal user.id, response_body.dig("shopping_list", "user_id")
  end

  test "updates a shopping list" do
    user = create_user(username: "shopping_update_owner", email: "shopping.update.owner@example.com")
    shopping_list = ShoppingList.create!(user: user, name: "Base", optional_description: "Inicial")

    patch "/api/shopping_lists/#{shopping_list.id}", params: {
      shopping_list: {
        name: "Base actualitzada",
        optional_description: "Canviada"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Base actualitzada", response_body.dig("shopping_list", "name")
    assert_equal "Canviada", shopping_list.reload.optional_description
  end

  test "deletes a shopping list" do
    user = create_user(username: "shopping_delete_owner", email: "shopping.delete.owner@example.com")
    shopping_list = ShoppingList.create!(user: user, name: "Temporal")

    delete "/api/shopping_lists/#{shopping_list.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list deleted", response_body["message"]
    assert_not ShoppingList.exists?(shopping_list.id)
  end

  test "returns not found for a missing shopping list" do
    get "/api/shopping_lists/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list not found", response_body.dig("error", "message")
  end

  test "returns validation errors when shopping list is invalid" do
    user = create_user(username: "shopping_invalid_owner", email: "shopping.invalid.owner@example.com")

    post "/api/shopping_lists", params: {
      shopping_list: {
        name: "",
        user_id: user.id
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "name").present?
  end

  test "returns validation errors when shopping list user is invalid" do
    post "/api/shopping_lists", params: {
      shopping_list: {
        name: "Setmana",
        user_id: 999999
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "user_id")
  end
end
