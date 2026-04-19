require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email and username before validation" do
    user = User.create!(
      username: " Arnau_User ",
      email: " Arnau@Example.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "arnau_user", user.username
    assert_equal "arnau@example.com", user.email
  end

  test "requires a secure password" do
    user = User.new(
      username: "short_password",
      email: "short@example.com",
      password: "short",
      password_confirmation: "short"
    )

    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end
end
