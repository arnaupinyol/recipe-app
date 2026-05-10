require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "registers a user and returns a token" do
    post "/api/auth/register", params: {
      user: {
        username: "arnau",
        email: "arnau@example.com",
        password: "password123",
        password_confirmation: "password123",
        language: "ca"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert response_body["token"].present?
    assert_equal "arnau", response_body.dig("user", "username")
    assert_equal "arnau@example.com", response_body.dig("user", "email")
  end

  test "logs in a user and returns a token" do
    User.create!(
      username: "login_user",
      email: "login@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    post "/api/auth/login", params: {
      user: {
        email: "login@example.com",
        password: "password123",
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert response_body["token"].present?
    assert_equal "login_user", response_body.dig("user", "username")
  end

  test "returns current user with a valid token" do
    User.create!(
      username: "login_cat",
      email: "logincat@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    post "/api/auth/login", params: {
      user: {
        email: "logincat@example.com",
        password: "password123"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert response_body["token"].present?
    assert_equal "login_cat", response_body.dig("user", "username")

    user = User.create!(
      username: "current_user",
      email: "current@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    token = JsonWebToken.encode(user_id: user.id)

    get "/api/auth/me", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "current_user", response_body.dig("user", "username")
    assert_equal "current@example.com", response_body.dig("user", "email")
  end

  test "rejects current user request without token" do
    get "/api/auth/me"

    assert_response :unauthorized

    response_body = JSON.parse(response.body)
    assert_equal "Unauthorized", response_body.dig("error", "message")
  end

  test "rejects invalid login" do
    post "/api/auth/login", params: {
      user: {
        email: "missing@example.com",
        password: "password123"
      }
    }, as: :json

    assert_response :unauthorized

    response_body = JSON.parse(response.body)
    assert_equal "Invalid email or password", response_body.dig("error", "message")
  end

  test "logs out a user and revokes the current token" do
    user = create_user(username: "logout_user", email: "logout@example.com")
    token = JsonWebToken.encode(user_id: user.id)

    delete "/api/auth/logout", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :success
    assert_equal "Logged out", response_json["message"]

    get "/api/auth/me", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :unauthorized
    assert_equal "Unauthorized", response_json.dig("error", "message")
  end
end
