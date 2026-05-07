require "test_helper"

class ShoppingListItemsTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def create_shopping_list_for(user:, name:)
    ShoppingList.create!(user: user, name: name)
  end

  test "lists shopping list items" do
    user = create_user(username: "list_item_owner", email: "list.item.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Compra")
    ingredient_1 = Ingredient.create!(name: "Poma")
    ingredient_2 = Ingredient.create!(name: "Llet")

    ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient_1, quantity: 2, unit_type: :units)
    ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient_2, quantity: 500, unit_type: :ml)

    get "/api/shopping_list_items"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["shopping_list_items"].length
    assert_equal [ "Poma", "Llet" ], response_body["shopping_list_items"].map { |item| item["ingredient_name"] }
  end

  test "shows a shopping list item" do
    user = create_user(username: "list_item_show_owner", email: "list.item.show.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Mercat")
    ingredient = Ingredient.create!(name: "Farina")
    item = ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient, quantity: 1000, unit_type: :grams)

    get "/api/shopping_list_items/#{item.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Mercat", response_body.dig("shopping_list_item", "shopping_list_name")
    assert_equal "Farina", response_body.dig("shopping_list_item", "ingredient_name")
    assert_equal "grams", response_body.dig("shopping_list_item", "unit_type")
  end

  test "creates a shopping list item" do
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
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal shopping_list.id, response_body.dig("shopping_list_item", "shopping_list_id")
    assert_equal ingredient.id, response_body.dig("shopping_list_item", "ingredient_id")
    assert_equal "units", response_body.dig("shopping_list_item", "unit_type")
  end

  test "updates a shopping list item" do
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
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal true, response_body.dig("shopping_list_item", "purchased")
    assert_equal "ml", response_body.dig("shopping_list_item", "unit_type")
    assert_equal 750, item.reload.quantity.to_i
  end

  test "deletes a shopping list item" do
    user = create_user(username: "list_item_delete_owner", email: "list.item.delete.owner@example.com")
    shopping_list = create_shopping_list_for(user: user, name: "Eliminar")
    ingredient = Ingredient.create!(name: "Mel")
    item = ShoppingListItem.create!(shopping_list: shopping_list, ingredient: ingredient, quantity: 1, unit_type: :units)

    delete "/api/shopping_list_items/#{item.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list item deleted", response_body["message"]
    assert_not ShoppingListItem.exists?(item.id)
  end

  test "returns not found for a missing shopping list item" do
    get "/api/shopping_list_items/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list item not found", response_body.dig("error", "message")
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
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list item creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "quantity").present?
  end

  test "returns validation errors when shopping list item relations are invalid" do
    post "/api/shopping_list_items", params: {
      shopping_list_item: {
        shopping_list_id: 999999,
        ingredient_id: 999998,
        quantity: 1,
        unit_type: "units"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Shopping list item creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "shopping_list_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "ingredient_id")
  end
end
