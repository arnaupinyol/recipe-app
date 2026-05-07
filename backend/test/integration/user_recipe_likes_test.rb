require "test_helper"

class UserRecipeLikesTest < ActionDispatch::IntegrationTest
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

  test "lists recipe likes" do
    user_1 = create_user(username: "like_owner_1", email: "like.owner.1@example.com")
    user_2 = create_user(username: "like_owner_2", email: "like.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Soup")
    recipe_2 = create_recipe_for(user: user_2, title: "Cake")

    UserRecipeLike.create!(user: user_1, recipe: recipe_1)
    UserRecipeLike.create!(user: user_2, recipe: recipe_2)

    get "/api/user_recipe_likes"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["user_recipe_likes"].length
  end

  test "shows a recipe like" do
    user = create_user(username: "like_show_owner", email: "like.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    like = UserRecipeLike.create!(user: user, recipe: recipe)

    get "/api/user_recipe_likes/#{like.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bread", response_body.dig("user_recipe_like", "recipe_title")
    assert_equal user.username, response_body.dig("user_recipe_like", "username")
  end

  test "creates a recipe like" do
    user = create_user(username: "like_create_owner", email: "like.create.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pizza")

    post "/api/user_recipe_likes", params: {
      user_recipe_like: {
        user_id: user.id,
        recipe_id: recipe.id
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal user.id, response_body.dig("user_recipe_like", "user_id")
    assert_equal recipe.id, response_body.dig("user_recipe_like", "recipe_id")
  end

  test "updates a recipe like" do
    user_1 = create_user(username: "like_update_owner_1", email: "like.update.owner.1@example.com")
    user_2 = create_user(username: "like_update_owner_2", email: "like.update.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Rice")
    recipe_2 = create_recipe_for(user: user_2, title: "Tea")
    like = UserRecipeLike.create!(user: user_1, recipe: recipe_1)

    patch "/api/user_recipe_likes/#{like.id}", params: {
      user_recipe_like: {
        user_id: user_2.id,
        recipe_id: recipe_2.id
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal user_2.id, response_body.dig("user_recipe_like", "user_id")
    assert_equal recipe_2.id, response_body.dig("user_recipe_like", "recipe_id")
  end

  test "deletes a recipe like" do
    user = create_user(username: "like_delete_owner", email: "like.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Salad")
    like = UserRecipeLike.create!(user: user, recipe: recipe)

    delete "/api/user_recipe_likes/#{like.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Recipe like deleted", response_body["message"]
    assert_not UserRecipeLike.exists?(like.id)
  end

  test "returns validation errors when like relations are invalid" do
    post "/api/user_recipe_likes", params: {
      user_recipe_like: {
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
