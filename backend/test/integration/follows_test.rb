require "test_helper"

class FollowsTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "lists follows" do
    follower = create_user(username: "follow_owner_1", email: "follow.owner.1@example.com")
    followed = create_user(username: "follow_owner_2", email: "follow.owner.2@example.com")

    Follow.create!(follower: follower, followed: followed)

    get "/api/follows"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 1, response_body["follows"].length
  end

  test "shows a follow" do
    follower = create_user(username: "follow_show_1", email: "follow.show.1@example.com")
    followed = create_user(username: "follow_show_2", email: "follow.show.2@example.com")
    follow = Follow.create!(follower: follower, followed: followed)

    get "/api/follows/#{follow.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal follower.username, response_body.dig("follow", "follower_username")
    assert_equal followed.username, response_body.dig("follow", "followed_username")
  end

  test "creates a follow" do
    follower = create_user(username: "follow_create_1", email: "follow.create.1@example.com")
    followed = create_user(username: "follow_create_2", email: "follow.create.2@example.com")

    post "/api/follows", params: {
      follow: {
        follower_id: follower.id,
        followed_id: followed.id
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal follower.id, response_body.dig("follow", "follower_id")
    assert_equal followed.id, response_body.dig("follow", "followed_id")
  end

  test "updates a follow" do
    follower = create_user(username: "follow_update_1", email: "follow.update.1@example.com")
    followed_1 = create_user(username: "follow_update_2", email: "follow.update.2@example.com")
    followed_2 = create_user(username: "follow_update_3", email: "follow.update.3@example.com")
    follow = Follow.create!(follower: follower, followed: followed_1)

    patch "/api/follows/#{follow.id}", params: {
      follow: {
        followed_id: followed_2.id
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal followed_2.id, response_body.dig("follow", "followed_id")
  end

  test "deletes a follow" do
    follower = create_user(username: "follow_delete_1", email: "follow.delete.1@example.com")
    followed = create_user(username: "follow_delete_2", email: "follow.delete.2@example.com")
    follow = Follow.create!(follower: follower, followed: followed)

    delete "/api/follows/#{follow.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Follow deleted", response_body["message"]
    assert_not Follow.exists?(follow.id)
  end

  test "returns validation errors when follow relations are invalid" do
    post "/api/follows", params: {
      follow: {
        follower_id: 999999,
        followed_id: 999998
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "follower_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "followed_id")
  end

  test "returns validation errors when following self" do
    user = create_user(username: "follow_self", email: "follow.self@example.com")

    post "/api/follows", params: {
      follow: {
        follower_id: user.id,
        followed_id: user.id
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert response_body.dig("error", "details", "followed_id").present?
  end
end
