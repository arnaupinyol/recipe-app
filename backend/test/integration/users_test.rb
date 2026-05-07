require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "lists users" do
    user_1 = create_user(username: "user_list_1", email: "user.list.1@example.com")
    user_2 = create_user(username: "user_list_2", email: "user.list.2@example.com")
    allergy = Allergy.create!(name: "Gluten")
    user_1.allergies << allergy

    get "/api/users"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["users"].length
    assert_equal [ "gluten" ], response_body["users"].find { |item| item["id"] == user_1.id }.fetch("allergies").map { |item| item["name"].downcase }
    assert_equal [ user_1.username, user_2.username ].sort, response_body["users"].map { |item| item["username"] }
  end

  test "shows a user" do
    user = create_user(username: "user_show", email: "user.show@example.com")
    allergy = Allergy.create!(name: "Lactose")
    user.allergies << allergy

    get "/api/users/#{user.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal user.username, response_body.dig("user", "username")
    assert_equal [ allergy.id ], response_body.dig("user", "allergy_ids")
    assert_equal [ "Lactose" ], response_body.dig("user", "allergies").map { |item| item["name"] }
  end

  test "creates a user" do
    allergy = Allergy.create!(name: "Egg")

    post "/api/users", params: {
      user: {
        username: " Arnau_User ",
        email: " Arnau.User@example.com ",
        password: "password123",
        password_confirmation: "password123",
        bio: "Fan of recipes",
        profile_image_url: "https://example.com/avatar.png",
        language: "en",
        private_profile: true,
        notifications_enabled: false,
        account_status: "active",
        role: "moderator",
        allergy_ids: [ allergy.id ]
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "arnau_user", response_body.dig("user", "username")
    assert_equal "arnau.user@example.com", response_body.dig("user", "email")
    assert_equal [ allergy.id ], response_body.dig("user", "allergy_ids")
    assert_equal "moderator", response_body.dig("user", "role")
  end

  test "updates a user" do
    user = create_user(username: "user_update", email: "user.update@example.com")
    allergy = Allergy.create!(name: "Peanut")

    patch "/api/users/#{user.id}", params: {
      user: {
        bio: "Updated bio",
        language: "es",
        private_profile: true,
        notifications_enabled: false,
        allergy_ids: [ allergy.id ]
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Updated bio", response_body.dig("user", "bio")
    assert_equal "es", response_body.dig("user", "language")
    assert_equal true, response_body.dig("user", "private_profile")
    assert_equal false, response_body.dig("user", "notifications_enabled")
    assert_equal [ allergy.id ], response_body.dig("user", "allergy_ids")
  end

  test "deletes a user" do
    user = create_user(username: "user_delete", email: "user.delete@example.com")

    delete "/api/users/#{user.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "User deleted", response_body["message"]
    assert_not User.exists?(user.id)
  end

  test "returns not found for a missing user" do
    get "/api/users/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "User not found", response_body.dig("error", "message")
  end

  test "returns validation errors when user is invalid" do
    post "/api/users", params: {
      user: {
        username: "",
        email: "invalid-email",
        password: "short",
        password_confirmation: "short",
        language: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "User creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "username").present?
    assert response_body.dig("error", "details", "email").present?
    assert response_body.dig("error", "details", "password").present?
    assert response_body.dig("error", "details", "language").present?
  end

  test "returns validation errors when user allergies are invalid" do
    post "/api/users", params: {
      user: {
        username: "user_invalid_allergies",
        email: "user.invalid.allergies@example.com",
        password: "password123",
        password_confirmation: "password123",
        allergy_ids: [ 999999 ]
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "User creation failed", response_body.dig("error", "message")
    assert_equal [ "contain invalid values" ], response_body.dig("error", "details", "allergy_ids")
  end
end
