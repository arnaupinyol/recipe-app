require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  test "lists users without exposing private fields" do
    user_1 = create_user(username: "user_list_1", email: "user.list.1@example.com")
    user_2 = create_user(username: "user_list_2", email: "user.list.2@example.com")
    allergy = Allergy.create!(name: "Gluten")
    user_1.allergies << allergy

    get "/api/users"

    assert_response :success

    listed_user = response_json["users"].find { |item| item["id"] == user_1.id }
    assert_equal [ user_1.username, user_2.username ].sort, response_json["users"].map { |item| item["username"] }
    assert_nil listed_user["email"]
    assert_nil listed_user["allergies"]
    assert_nil listed_user["role"]
  end

  test "shows a public user profile without private fields" do
    user = create_user(username: "user_show", email: "user.show@example.com", bio: "Cook")
    allergy = Allergy.create!(name: "Lactose")
    user.allergies << allergy

    get "/api/users/#{user.id}"

    assert_response :success

    assert_equal user.username, response_json.dig("user", "username")
    assert_equal "Cook", response_json.dig("user", "bio")
    assert_nil response_json.dig("user", "email")
    assert_nil response_json.dig("user", "allergies")
  end

  test "shows private fields to the same authenticated user" do
    user = create_user(username: "user_private", email: "user.private@example.com", language: "es")
    allergy = Allergy.create!(name: "Peanut")
    user.allergies << allergy

    get "/api/users/#{user.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "user.private@example.com", response_json.dig("user", "email")
    assert_equal "es", response_json.dig("user", "language")
    assert_equal [ allergy.id ], response_json.dig("user", "allergy_ids")
  end

  test "allows staff to create a user" do
    admin = create_user(username: "admin_user", email: "admin@example.com", role: :admin)
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
    }, headers: auth_headers_for(admin), as: :json

    assert_response :created

    assert_equal "arnau_user", response_json.dig("user", "username")
    assert_equal "arnau.user@example.com", response_json.dig("user", "email")
    assert_equal [ allergy.id ], response_json.dig("user", "allergy_ids")
    assert_equal "moderator", response_json.dig("user", "role")
  end

  test "rejects user creation for non staff users" do
    user = create_user(username: "plain_user", email: "plain.user@example.com")

    post "/api/users", params: {
      user: {
        username: "new_user",
        email: "new.user@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "updates the current user without allowing role escalation" do
    user = create_user(username: "user_update", email: "user.update@example.com")
    allergy = Allergy.create!(name: "Peanut")

    patch "/api/users/#{user.id}", params: {
      user: {
        bio: "Updated bio",
        language: "es",
        private_profile: true,
        notifications_enabled: false,
        role: "admin",
        allergy_ids: [ allergy.id ]
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success

    assert_equal "Updated bio", response_json.dig("user", "bio")
    assert_equal "es", response_json.dig("user", "language")
    assert_equal true, response_json.dig("user", "private_profile")
    assert_equal false, response_json.dig("user", "notifications_enabled")
    assert_equal [ allergy.id ], response_json.dig("user", "allergy_ids")
    assert_equal "user", user.reload.role
  end

  test "prevents updating another user without admin role" do
    user = create_user(username: "user_one", email: "user.one@example.com")
    other_user = create_user(username: "user_two", email: "user.two@example.com")

    patch "/api/users/#{other_user.id}", params: {
      user: {
        bio: "Intrusion"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "deletes the current user" do
    user = create_user(username: "user_delete", email: "user.delete@example.com")

    delete "/api/users/#{user.id}", headers: auth_headers_for(user)

    assert_response :success

    assert_equal "User deleted", response_json["message"]
    assert_not User.exists?(user.id)
  end

  test "returns not found for a missing user" do
    get "/api/users/999999"

    assert_response :not_found
    assert_equal "User not found", response_json.dig("error", "message")
  end

  test "returns validation errors when created user is invalid" do
    admin = create_user(username: "admin_invalid", email: "admin.invalid@example.com", role: :admin)

    post "/api/users", params: {
      user: {
        username: "",
        email: "invalid-email",
        password: "short",
        password_confirmation: "short",
        language: ""
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :unprocessable_entity

    assert_equal "User creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "username").present?
    assert response_json.dig("error", "details", "email").present?
    assert response_json.dig("error", "details", "password").present?
    assert response_json.dig("error", "details", "language").present?
  end

  test "returns validation errors when created user allergies are invalid" do
    admin = create_user(username: "admin_allergy", email: "admin.allergy@example.com", role: :admin)

    post "/api/users", params: {
      user: {
        username: "user_invalid_allergies",
        email: "user.invalid.allergies@example.com",
        password: "password123",
        password_confirmation: "password123",
        allergy_ids: [ 999999 ]
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :unprocessable_entity

    assert_equal "User creation failed", response_json.dig("error", "message")
    assert_equal [ "contain invalid values" ], response_json.dig("error", "details", "allergy_ids")
  end
end
