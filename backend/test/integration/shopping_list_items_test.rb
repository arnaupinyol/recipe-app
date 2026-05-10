require "test_helper"

class ShoppingListItemsTest < ActionDispatch::IntegrationTest
  def create_shopping_list_for(user:, name:)
    ShoppingList.create!(user: user, name: name)
  end

  test "lists only the current user's shopping list items" do
    user = create_user(username: "list_item_owner", email: "list.item.owner@example.com")
    other_user = create_user(username: "list_item_other", email: "list.item.other@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Compra")
    other_shopping_list = create_shopping_list_for(user: other_user, name: "Altre")
    ingredient_1 = Ingredient.create!(name: "Poma")
    ingredient_2 = Ingredient.create!(name: "Llet")

    ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient_1, quantity: 2, unit_type: :units)
    ShoppingListItem.create!(shopping_list: other_shopping_list, ingredient: ingredient_2, quantity: 500, unit_type: :ml)

    get "/api/shopping_list_items", headers: auth_headers_for(user)

    assert_response :success

    assert_equal [ "Poma" ], response_json["shopping_list_items"].map { |item| item["ingredient_name"] }
  end

  test "shows an owned shopping list item" do
    user = create_user(username: "list_item_show_owner", email: "list.item.show.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Mercat")
    ingredient = Ingredient.create!(name: "Farina")
    item = ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient, quantity: 1000, unit_type: :grams)

    get "/api/shopping_list_items/#{item.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Mercat", response_json.dig("shopping_list_item", "shopping_list_name")
    assert_equal "Farina", response_json.dig("shopping_list_item", "ingredient_name")
    assert_equal "grams", response_json.dig("shopping_list_item", "unit_type")
  end

  test "creates a shopping list item in an owned shopping list" do
    user = create_user(username: "list_item_create_owner", email: "list.item.create.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Setmana")
    ingredient = Ingredient.create!(name: "Iogurt")

    post "/api/shopping_list_items", params: {
      shopping_list_item: {
        shopping_list_id: shopping_list.id,
        ingredient_id: ingredient.id,
        quantity: 4,
        unit_type: "units",
        purchased: false
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created

    assert_equal shopping_list.id, response_json.dig("shopping_list_item", "shopping_list_id")
    assert_equal ingredient.id, response_json.dig("shopping_list_item", "ingredient_id")
    assert_equal "units", response_json.dig("shopping_list_item", "unit_type")
  end

  test "updates an owned shopping list item" do
    user = create_user(username: "list_item_update_owner", email: "list.item.update.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Capsa")
    ingredient = Ingredient.create!(name: "Suc")
    item = ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient, quantity: 1, unit_type: :units)

    patch "/api/shopping_list_items/#{item.id}", params: {
      shopping_list_item: {
        quantity: 750,
        unit_type: "ml",
        purchased: true
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success

    assert_equal true, response_json.dig("shopping_list_item", "purchased")
    assert_equal "ml", response_json.dig("shopping_list_item", "unit_type")
    assert_equal 750, item.reload.quantity.to_i
  end

  test "rejects another user's shopping list on create" do
    user = create_user(username: "list_item_intruder", email: "list.item.intruder@example.com")
    owner = create_user(username: "list_item_owner_two", email: "list.item.owner.two@example.com")
    shopping_list = create_shopping_list_for(user: owner, name: "Privada")
    ingredient = Ingredient.create!(name: "Mel")

    post "/api/shopping_list_items", params: {
      shopping_list_item: {
        shopping_list_id: shopping_list.id,
        ingredient_id: ingredient.id,
        quantity: 1,
        unit_type: "units"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "shopping_list_id")
  end

  test "deletes a shopping list item" do
    user = create_user(username: "list_item_delete_owner", email: "list.item.delete.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Eliminar")
    ingredient = Ingredient.create!(name: "Mel")
    item = ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient, quantity: 1, unit_type: :units)

    delete "/api/shopping_list_items/#{item.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Shopping list item deleted", response_json["message"]
    assert_not ShoppingListItem.exists?(item.id)
  end

  test "returns not found for a missing shopping list item" do
    user = create_user(username: "list_item_missing_owner", email: "list.item.missing.owner@example.com")

    get "/api/shopping_list_items/999999", headers: auth_headers_for(user)

    assert_response :not_found
    assert_equal "Shopping list item not found", response_json.dig("error", "message")
  end

  test "returns validation errors when shopping list item is invalid" do
    user = create_user(username: "list_item_invalid_owner", email: "list.item.invalid.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Error")
    ingredient = Ingredient.create!(name: "Aigua")

    post "/api/shopping_list_items", params: {
      shopping_list_item: {
        shopping_list_id: shopping_list.id,
        ingredient_id: ingredient.id,
        quantity: 0,
        unit_type: "units"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Shopping list item creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "quantity").present?
  end

  test "returns validation errors when shopping list item relations are invalid" do
    user = create_user(username: "list_item_invalid_rel", email: "list.item.invalid.rel@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Error rel")

    post "/api/shopping_list_items", params: {
      shopping_list_item: {
        shopping_list_id: shopping_list.id,
        ingredient_id: 999998,
        quantity: 1,
        unit_type: "units"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Shopping list item creation failed", response_json.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "ingredient_id")
  end
end
