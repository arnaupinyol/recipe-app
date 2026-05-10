require "test_helper"

class CommentsTest < ActionDispatch::IntegrationTest
  test "lists comments for visible recipes" do
    user_1 = create_user(username: "comment_owner_1", email: "comment.owner.1@example.com")
    user_2 = create_user(username: "comment_owner_2", email: "comment.owner.2@example.com")
    recipe_1 = create_recipe_for(user: user_1, title: "Crema de verdures")
    recipe_2 = create_recipe_for(user: user_2, title: "Risotto", visibility: :private_recipe)

    Comment.create!(user: user_1, recipe: recipe_1, text: "Molt bona", rating: 9)
    Comment.create!(user: user_2, recipe: recipe_2, text: "Perfecta", rating: 10)

    get "/api/comments"

    assert_response :success

    assert_equal [ "Molt bona" ], response_json["comments"].map { |comment| comment["text"] }
  end

  test "shows a comment for a visible recipe" do
    user = create_user(username: "comment_show_owner", email: "comment.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Amanida")
    comment = Comment.create!(user: user, recipe: recipe, text: "Fresca", rating: 8)

    get "/api/comments/#{comment.id}"

    assert_response :success

    assert_equal "Fresca", response_json.dig("comment", "text")
    assert_equal user.username, response_json.dig("comment", "username")
    assert_equal recipe.title, response_json.dig("comment", "recipe_title")
  end

  test "creates a comment for the authenticated user" do
    user = create_user(username: "comment_create_owner", email: "comment.create.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pastis de formatge")

    post "/api/comments", params: {
      comment: {
        text: "Espectacular",
        rating: 10,
        user_id: 999999,
        recipe_id: recipe.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created

    assert_equal "Espectacular", response_json.dig("comment", "text")
    assert_equal user.id, response_json.dig("comment", "user_id")
    assert_equal recipe.id, response_json.dig("comment", "recipe_id")
  end

  test "rejects comment creation without authentication" do
    recipe_owner = create_user(username: "comment_guest_owner", email: "comment.guest.owner@example.com")
    recipe = create_recipe_for(user: recipe_owner, title: "Pastis")

    post "/api/comments", params: {
      comment: {
        text: "Anonim",
        rating: 5,
        recipe_id: recipe.id
      }
    }, as: :json

    assert_response :unauthorized
    assert_equal "Unauthorized", response_json.dig("error", "message")
  end

  test "updates a comment only for its owner" do
    user = create_user(username: "comment_update_owner", email: "comment.update.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pizza")
    comment = Comment.create!(user: user, recipe: recipe, text: "Bona", rating: 7)

    patch "/api/comments/#{comment.id}", params: {
      comment: {
        text: "Bonissima",
        rating: 9
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success

    assert_equal "Bonissima", response_json.dig("comment", "text")
    assert_equal 9, response_json.dig("comment", "rating")
    assert_equal "Bonissima", comment.reload.text
  end

  test "prevents updating another user's comment" do
    owner = create_user(username: "comment_owner", email: "comment.owner@example.com")
    intruder = create_user(username: "comment_intruder", email: "comment.intruder@example.com")
    recipe = create_recipe_for(user: owner, title: "Burger")
    comment = Comment.create!(user: owner, recipe: recipe, text: "Correcta", rating: 6)

    patch "/api/comments/#{comment.id}", params: {
      comment: {
        text: "Hack"
      }
    }, headers: auth_headers_for(intruder), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "deletes a comment" do
    user = create_user(username: "comment_delete_owner", email: "comment.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Hamburguesa")
    comment = Comment.create!(user: user, recipe: recipe, text: "Correcta", rating: 6)

    delete "/api/comments/#{comment.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "Comment deleted", response_json["message"]
    assert_not Comment.exists?(comment.id)
  end

  test "returns not found for a missing comment" do
    get "/api/comments/999999"

    assert_response :not_found
    assert_equal "Comment not found", response_json.dig("error", "message")
  end

  test "returns validation errors when comment is invalid" do
    user = create_user(username: "comment_invalid_owner", email: "comment.invalid.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Sushi")

    post "/api/comments", params: {
      comment: {
        text: "",
        rating: 11,
        recipe_id: recipe.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Comment creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "text").present?
    assert response_json.dig("error", "details", "rating").present?
  end

  test "returns validation errors when comment recipe is invalid" do
    user = create_user(username: "comment_invalid_rel", email: "comment.invalid.rel@example.com")

    post "/api/comments", params: {
      comment: {
        text: "Text",
        rating: 5,
        recipe_id: 999998
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Comment creation failed", response_json.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "recipe_id")
  end

  test "returns validation errors when a user comments the same recipe twice" do
    user = create_user(username: "comment_unique_owner", email: "comment.unique.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Lasanya")
    Comment.create!(user: user, recipe: recipe, text: "Molt bona", rating: 8)

    post "/api/comments", params: {
      comment: {
        text: "Repetida",
        rating: 7,
        recipe_id: recipe.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity

    assert_equal "Comment creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "user_id").present?
  end
end
