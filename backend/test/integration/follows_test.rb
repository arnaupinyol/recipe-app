require "test_helper"

class FollowsTest < ActionDispatch::IntegrationTest
  test "lists only the current user's follows" do
    follower = create_user(username: "follow_owner_1", email: "follow.owner.1@example.com")
    other_follower = create_user(username: "follow_owner_2", email: "follow.owner.2@example.com")
    followed = create_user(username: "follow_target_1", email: "follow.target.1@example.com")
    other_followed = create_user(username: "follow_target_2", email: "follow.target.2@example.com")

    Follow.create!(follower: follower, followed: followed)
    Follow.create!(follower: other_follower, followed: other_followed)

    get "/api/follows", headers: auth_headers_for(follower)

    assert_response :success
    assert_equal 1, response_json["follows"].length
    assert_equal followed.id, response_json.dig("follows", 0, "followed_id")
  end

  test "shows an owned follow" do
    follower = create_user(username: "follow_show_1", email: "follow.show.1@example.com")
    followed = create_user(username: "follow_show_2", email: "follow.show.2@example.com")
    follow = Follow.create!(follower: follower, followed: followed)

    get "/api/follows/#{follow.id}", headers: auth_headers_for(follower)

    assert_response :success
    assert_equal follower.username, response_json.dig("follow", "follower_username")
    assert_equal followed.username, response_json.dig("follow", "followed_username")
  end

  test "creates a follow for the authenticated user" do
    follower = create_user(username: "follow_create_1", email: "follow.create.1@example.com")
    followed = create_user(username: "follow_create_2", email: "follow.create.2@example.com")

    post "/api/follows", params: {
      follow: {
        follower_id: 999999,
        followed_id: followed.id
      }
    }, headers: auth_headers_for(follower), as: :json

    assert_response :created
    assert_equal follower.id, response_json.dig("follow", "follower_id")
    assert_equal followed.id, response_json.dig("follow", "followed_id")
  end

  test "updates an owned follow" do
    follower = create_user(username: "follow_update_1", email: "follow.update.1@example.com")
    followed_1 = create_user(username: "follow_update_2", email: "follow.update.2@example.com")
    followed_2 = create_user(username: "follow_update_3", email: "follow.update.3@example.com")
    follow = Follow.create!(follower: follower, followed: followed_1)

    patch "/api/follows/#{follow.id}", params: {
      follow: {
        followed_id: followed_2.id
      }
    }, headers: auth_headers_for(follower), as: :json

    assert_response :success
    assert_equal followed_2.id, response_json.dig("follow", "followed_id")
  end

  test "deletes a follow" do
    follower = create_user(username: "follow_delete_1", email: "follow.delete.1@example.com")
    followed = create_user(username: "follow_delete_2", email: "follow.delete.2@example.com")
    follow = Follow.create!(follower: follower, followed: followed)

    delete "/api/follows/#{follow.id}", headers: auth_headers_for(follower)

    assert_response :success
    assert_equal "Follow deleted", response_json["message"]
    assert_not Follow.exists?(follow.id)
  end

  test "returns validation errors when followed user is invalid" do
    follower = create_user(username: "follow_invalid_rel", email: "follow.invalid.rel@example.com")

    post "/api/follows", params: {
      follow: {
        followed_id: 999998
      }
    }, headers: auth_headers_for(follower), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "followed_id")
  end

  test "returns validation errors when following self" do
    user = create_user(username: "follow_self", email: "follow.self@example.com")

    post "/api/follows", params: {
      follow: {
        followed_id: user.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert response_json.dig("error", "details", "followed_id").present?
  end
end
