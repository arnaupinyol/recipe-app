require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  def build_user(suffix = "recipe")
    User.new(
      username: "user_#{suffix}",
      email: "#{suffix}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "is invalid when difficulty is outside the accepted range" do
    recipe = Recipe.new(
      user: build_user("difficulty"),
      title: "Starter",
      preparation_time_minutes: 10,
      difficulty: 7,
      servings: 2
    )

    assert_not recipe.valid?
    assert_includes recipe.errors[:difficulty], "must be less than or equal to 5"
  end
end
