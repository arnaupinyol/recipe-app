require "test_helper"

class CommentsTest < ActionDispatch::IntegrationTest
  def create_user_and_recipe(username:, email:, title:)
    user = User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
    recipe = Recipe.create!(
      user: user,
      title: title,
      description: "Recipe description",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 2
    )

    [ user, recipe ]
  end

  test "lists comments" do
    user_1, recipe_1 = create_user_and_recipe(
      username: "comment_owner_1",
      email: "comment.owner.1@example.com",
      title: "Crema de verdures"
    )
    user_2, recipe_2 = create_user_and_recipe(
      username: "comment_owner_2",
      email: "comment.owner.2@example.com",
      title: "Risotto"
    )

    Comment.create!(user: user_1, recipe: recipe_1, text: "Molt bona", rating: 9)
    Comment.create!(user: user_2, recipe: recipe_2, text: "Perfecta", rating: 10)

    get "/api/comments"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["comments"].length
    assert_equal [ "Perfecta", "Molt bona" ], response_body["comments"].map { |comment| comment["text"] }
  end

  test "shows a comment" do
    user, recipe = create_user_and_recipe(
      username: "comment_show_owner",
      email: "comment.show.owner@example.com",
      title: "Amanida"
    )
    comment = Comment.create!(user: user, recipe: recipe, text: "Fresca", rating: 8)

    get "/api/comments/#{comment.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Fresca", response_body.dig("comment", "text")
    assert_equal user.username, response_body.dig("comment", "username")
    assert_equal recipe.title, response_body.dig("comment", "recipe_title")
  end

  test "creates a comment" do
    user, recipe = create_user_and_recipe(
      username: "comment_create_owner",
      email: "comment.create.owner@example.com",
      title: "Pastis de formatge"
    )

    post "/api/comments", params: {
      comment: {
        text: "Espectacular",
        rating: 10,
        user_id: user.id,
        recipe_id: recipe.id
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Espectacular", response_body.dig("comment", "text")
    assert_equal user.id, response_body.dig("comment", "user_id")
    assert_equal recipe.id, response_body.dig("comment", "recipe_id")
  end

  test "updates a comment" do
    user, recipe = create_user_and_recipe(
      username: "comment_update_owner",
      email: "comment.update.owner@example.com",
      title: "Pizza"
    )
    comment = Comment.create!(user: user, recipe: recipe, text: "Bona", rating: 7)

    patch "/api/comments/#{comment.id}", params: {
      comment: {
        text: "Bonissima",
        rating: 9
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bonissima", response_body.dig("comment", "text")
    assert_equal 9, response_body.dig("comment", "rating")
    assert_equal "Bonissima", comment.reload.text
  end

  test "deletes a comment" do
    user, recipe = create_user_and_recipe(
      username: "comment_delete_owner",
      email: "comment.delete.owner@example.com",
      title: "Hamburguesa"
    )
    comment = Comment.create!(user: user, recipe: recipe, text: "Correcta", rating: 6)

    delete "/api/comments/#{comment.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Comment deleted", response_body["message"]
    assert_not Comment.exists?(comment.id)
  end

  test "returns not found for a missing comment" do
    get "/api/comments/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Comment not found", response_body.dig("error", "message")
  end

  test "returns validation errors when comment is invalid" do
    user, recipe = create_user_and_recipe(
      username: "comment_invalid_owner",
      email: "comment.invalid.owner@example.com",
      title: "Sushi"
    )

    post "/api/comments", params: {
      comment: {
        text: "",
        rating: 11,
        user_id: user.id,
        recipe_id: recipe.id
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Comment creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "text").present?
    assert response_body.dig("error", "details", "rating").present?
  end

  test "returns validation errors when comment relations are invalid" do
    post "/api/comments", params: {
      comment: {
        text: "Text",
        rating: 5,
        user_id: 999999,
        recipe_id: 999998
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Comment creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "user_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "recipe_id")
  end

  test "returns validation errors when a user comments the same recipe twice" do
    user, recipe = create_user_and_recipe(
      username: "comment_unique_owner",
      email: "comment.unique.owner@example.com",
      title: "Lasanya"
    )
    Comment.create!(user: user, recipe: recipe, text: "Molt bona", rating: 8)

    post "/api/comments", params: {
      comment: {
        text: "Repetida",
        rating: 7,
        user_id: user.id,
        recipe_id: recipe.id
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Comment creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "user_id").present?
  end
end
