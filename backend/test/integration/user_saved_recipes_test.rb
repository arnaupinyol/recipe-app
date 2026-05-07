require "test_helper"

class UserSavedRecipesTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def create_recipe_for(user:, title:)
    Recipe.create!(
      user: user,
      title: title,
      description: "Recipe description",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 2
    )
  end

  test "lists saved recipes" do
    user_1 = create_user(username: "save_owner_1", email: "save.owner.1@example.com")
    user_2 = create_user(username: "save_owner_2", email: "save.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Soup")
    recipe_2 = create_recipe_for(user: user_2, title: "Cake")

    UserSavedRecipe.create!(user: user_1, recipe: recipe_1)
    UserSavedRecipe.create!(user: user_2, recipe: recipe_2)

    get "/api/user_saved_recipes"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["user_saved_recipes"].length
  end

  test "shows a saved recipe" do
    user = create_user(username: "save_show_owner", email: "save.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    saved_recipe = UserSavedRecipe.create!(user: user, recipe: recipe)

    get "/api/user_saved_recipes/#{saved_recipe.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bread", response_body.dig("user_saved_recipe", "recipe_title")
  end

  test "creates a saved recipe" do
    user = create_user(username: "save_create_owner", email: "save.create.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pizza")

    post "/api/user_saved_recipes", params: {
      user_saved_recipe: {
        user_id: user.id,
        recipe_id: recipe.id
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal user.id, response_body.dig("user_saved_recipe", "user_id")
    assert_equal recipe.id, response_body.dig("user_saved_recipe", "recipe_id")
  end

  test "updates a saved recipe" do
    user_1 = create_user(username: "save_update_owner_1", email: "save.update.owner.1@example.com")
    user_2 = create_user(username: "save_update_owner_2", email: "save.update.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Rice")
    recipe_2 = create_recipe_for(user: user_2, title: "Tea")
    saved_recipe = UserSavedRecipe.create!(user: user_1, recipe: recipe_1)

    patch "/api/user_saved_recipes/#{saved_recipe.id}", params: {
      user_saved_recipe: {
        user_id: user_2.id,
        recipe_id: recipe_2.id
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal user_2.id, response_body.dig("user_saved_recipe", "user_id")
    assert_equal recipe_2.id, response_body.dig("user_saved_recipe", "recipe_id")
  end

  test "deletes a saved recipe" do
    user = create_user(username: "save_delete_owner", email: "save.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Salad")
    saved_recipe = UserSavedRecipe.create!(user: user, recipe: recipe)

    delete "/api/user_saved_recipes/#{saved_recipe.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Saved recipe deleted", response_body["message"]
    assert_not UserSavedRecipe.exists?(saved_recipe.id)
  end

  test "returns validation errors when saved recipe relations are invalid" do
    post "/api/user_saved_recipes", params: {
      user_saved_recipe: {
        user_id: 999999,
        recipe_id: 999998
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "user_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "recipe_id")
  end
end
