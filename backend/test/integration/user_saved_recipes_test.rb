require "test_helper"

class UserSavedRecipesTest < ActionDispatch::IntegrationTest
  test "lists only the current user's saved recipes" do
    user_1 = create_user(username: "save_owner_1", email: "save.owner.1@example.com")
    user_2 = create_user(username: "save_owner_2", email: "save.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Soup")
    recipe_2 = create_recipe_for(user: user_2, title: "Cake")

    UserSavedRecipe.create!(user: user_1, recipe: recipe_1)
    UserSavedRecipe.create!(user: user_2, recipe: recipe_2)

    get "/api/user_saved_recipes", headers: auth_headers_for(user_1)

    assert_response :success
    assert_equal 1, response_json["user_saved_recipes"].length
    assert_equal recipe_1.id, response_json.dig("user_saved_recipes", 0, "recipe_id")
  end

  test "shows an owned saved recipe" do
    user = create_user(username: "save_show_owner", email: "save.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    saved_recipe = UserSavedRecipe.create!(user: user, recipe: recipe)

    get "/api/user_saved_recipes/#{saved_recipe.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Bread", response_json.dig("user_saved_recipe", "recipe_title")
  end

  test "creates a saved recipe for the authenticated user" do
    user = create_user(username: "save_create_owner", email: "save.create.owner@example.com")
    recipe_owner = create_user(username: "save_recipe_owner", email: "save.recipe.owner@example.com")
    recipe = create_recipe_for(user: recipe_owner, title: "Pizza")

    post "/api/user_saved_recipes", params: {
      user_saved_recipe: {
        user_id: 999999,
        recipe_id: recipe.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created

    assert_equal user.id, response_json.dig("user_saved_recipe", "user_id")
    assert_equal recipe.id, response_json.dig("user_saved_recipe", "recipe_id")
  end

  test "updates an owned saved recipe" do
    user = create_user(username: "save_update_owner", email: "save.update.owner@example.com")
    recipe_owner = create_user(username: "save_recipe_owner_2", email: "save.recipe.owner.2@example.com")
    recipe_1 = create_recipe_for(user: recipe_owner, title: "Rice")
    recipe_2 = create_recipe_for(user: recipe_owner, title: "Tea")
    saved_recipe = UserSavedRecipe.create!(user: user, recipe: recipe_1)

    patch "/api/user_saved_recipes/#{saved_recipe.id}", params: {
      user_saved_recipe: {
        recipe_id: recipe_2.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success
    assert_equal recipe_2.id, response_json.dig("user_saved_recipe", "recipe_id")
  end

  test "deletes a saved recipe" do
    user = create_user(username: "save_delete_owner", email: "save.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Salad")
    saved_recipe = UserSavedRecipe.create!(user: user, recipe: recipe)

    delete "/api/user_saved_recipes/#{saved_recipe.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Saved recipe deleted", response_json["message"]
    assert_not UserSavedRecipe.exists?(saved_recipe.id)
  end

  test "returns validation errors when recipe is invalid" do
    user = create_user(username: "save_invalid_rel", email: "save.invalid.rel@example.com")

    post "/api/user_saved_recipes", params: {
      user_saved_recipe: {
        recipe_id: 999998
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "recipe_id")
  end
end
