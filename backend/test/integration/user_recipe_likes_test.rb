require "test_helper"

class UserRecipeLikesTest < ActionDispatch::IntegrationTest
  test "lists only the current user's recipe likes" do
    user_1 = create_user(username: "like_owner_1", email: "like.owner.1@example.com")
    user_2 = create_user(username: "like_owner_2", email: "like.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Soup")
    recipe_2 = create_recipe_for(user: user_2, title: "Cake")

    UserRecipeLike.create!(user: user_1, recipe: recipe_1)
    UserRecipeLike.create!(user: user_2, recipe: recipe_2)

    get "/api/user_recipe_likes", headers: auth_headers_for(user_1)

    assert_response :success
    assert_equal 1, response_json["user_recipe_likes"].length
    assert_equal recipe_1.id, response_json.dig("user_recipe_likes", 0, "recipe_id")
  end

  test "shows an owned recipe like" do
    user = create_user(username: "like_show_owner", email: "like.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    like = UserRecipeLike.create!(user: user, recipe: recipe)

    get "/api/user_recipe_likes/#{like.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Bread", response_json.dig("user_recipe_like", "recipe_title")
    assert_equal user.username, response_json.dig("user_recipe_like", "username")
  end

  test "creates a recipe like for the authenticated user" do
    user = create_user(username: "like_create_owner", email: "like.create.owner@example.com")
    recipe_owner = create_user(username: "like_recipe_owner", email: "like.recipe.owner@example.com")
    recipe = create_recipe_for(user: recipe_owner, title: "Pizza")

    post "/api/user_recipe_likes", params: {
      user_recipe_like: {
        user_id: 999999,
        recipe_id: recipe.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created

    assert_equal user.id, response_json.dig("user_recipe_like", "user_id")
    assert_equal recipe.id, response_json.dig("user_recipe_like", "recipe_id")
  end

  test "updates an owned recipe like" do
    user = create_user(username: "like_update_owner", email: "like.update.owner@example.com")
    recipe_owner = create_user(username: "like_recipe_owner_2", email: "like.recipe.owner.2@example.com")
    recipe_1 = create_recipe_for(user: recipe_owner, title: "Rice")
    recipe_2 = create_recipe_for(user: recipe_owner, title: "Tea")
    like = UserRecipeLike.create!(user: user, recipe: recipe_1)

    patch "/api/user_recipe_likes/#{like.id}", params: {
      user_recipe_like: {
        recipe_id: recipe_2.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success
    assert_equal recipe_2.id, response_json.dig("user_recipe_like", "recipe_id")
  end

  test "deletes a recipe like" do
    user = create_user(username: "like_delete_owner", email: "like.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Salad")
    like = UserRecipeLike.create!(user: user, recipe: recipe)

    delete "/api/user_recipe_likes/#{like.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Recipe like deleted", response_json["message"]
    assert_not UserRecipeLike.exists?(like.id)
  end

  test "returns validation errors when recipe is invalid" do
    user = create_user(username: "like_invalid_rel", email: "like.invalid.rel@example.com")

    post "/api/user_recipe_likes", params: {
      user_recipe_like: {
        recipe_id: 999998
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "recipe_id")
  end
end
