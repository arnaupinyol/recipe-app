require "test_helper"

class ShoppingListsTest < ActionDispatch::IntegrationTest
  test "lists only the current user's shopping lists" do
    user_1 = create_user(username: "shopping_owner_1", email: "shopping.owner.1@example.com")
    user_2 = create_user(username: "shopping_owner_2", email: "shopping.owner.2@example.com")

    ShoppingList.create!(user: user_1, name: "Setmana", optional_description: "Compra principal")
    ShoppingList.create!(user: user_2, name: "Cap de setmana", optional_description: "Extra")

    get "/api/shopping_lists", headers: auth_headers_for(user_1)

    assert_response :success
    assert_equal [ "Setmana" ], response_json["shopping_lists"].map { |shopping_list| shopping_list["name"] }
  end

  test "requires authentication to list shopping lists" do
    get "/api/shopping_lists"

    assert_response :unauthorized
    assert_equal "Unauthorized", response_json.dig("error", "message")
  end

  test "shows an owned shopping list" do
    user = create_user(username: "shopping_show_owner", email: "shopping.show.owner@example.com")
    shopping_list = ShoppingList.create!(user: user, name: "Mercat", optional_description: "Dissabte")

    get "/api/shopping_lists/#{shopping_list.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Mercat", response_json.dig("shopping_list", "name")
    assert_equal user.username, response_json.dig("shopping_list", "username")
  end

  test "creates a shopping list for the authenticated user" do
    user = create_user(username: "shopping_create_owner", email: "shopping.create.owner@example.com")

    post "/api/shopping_lists", params: {
      shopping_list: {
        name: "Fruita",
        optional_description: "Per tota la setmana",
        user_id: 999999
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created

    assert_equal "Fruita", response_json.dig("shopping_list", "name")
    assert_equal user.id, response_json.dig("shopping_list", "user_id")
  end

  test "updates an owned shopping list" do
    user = create_user(username: "shopping_update_owner", email: "shopping.update.owner@example.com")
    shopping_list = ShoppingList.create!(user: user, name: "Base", optional_description: "Inicial")

    patch "/api/shopping_lists/#{shopping_list.id}", params: {
      shopping_list: {
        name: "Base actualitzada",
        optional_description: "Canviada"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success

    assert_equal "Base actualitzada", response_json.dig("shopping_list", "name")
    assert_equal "Canviada", shopping_list.reload.optional_description
  end

  test "hides another user's shopping list" do
    owner = create_user(username: "shopping_owner", email: "shopping.owner@example.com")
    other_user = create_user(username: "shopping_other", email: "shopping.other@example.com")
    shopping_list = ShoppingList.create!(user: owner, name: "Privada")

    get "/api/shopping_lists/#{shopping_list.id}", headers: auth_headers_for(other_user)

    assert_response :not_found
    assert_equal "Shopping list not found", response_json.dig("error", "message")
  end

  test "deletes a shopping list" do
    user = create_user(username: "shopping_delete_owner", email: "shopping.delete.owner@example.com")
    shopping_list = ShoppingList.create!(user: user, name: "Temporal")

    delete "/api/shopping_lists/#{shopping_list.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Shopping list deleted", response_json["message"]
    assert_not ShoppingList.exists?(shopping_list.id)
  end

  test "returns not found for a missing shopping list" do
    user = create_user(username: "shopping_missing_owner", email: "shopping.missing.owner@example.com")

    get "/api/shopping_lists/999999", headers: auth_headers_for(user)

    assert_response :not_found
    assert_equal "Shopping list not found", response_json.dig("error", "message")
  end

  test "returns validation errors when shopping list is invalid" do
    user = create_user(username: "shopping_invalid_owner", email: "shopping.invalid.owner@example.com")

    post "/api/shopping_lists", params: {
      shopping_list: {
        name: ""
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Shopping list creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "name").present?
  end
end
