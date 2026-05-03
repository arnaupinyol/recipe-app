require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def create_user(suffix)
    User.create!(
      username: "user_#{suffix}",
      email: "#{suffix}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def create_recipe(user, suffix)
    Recipe.create!(
      user: user,
      title: "Recipe #{suffix}",
      preparation_time_minutes: 15,
      difficulty: 3,
      servings: 2
    )
  end

  test "requires ratings between 1 and 10" do
    user = create_user("comment_rating")
    recipe = create_recipe(user, "rating")

    comment = Comment.new(
      user: user,
      recipe: recipe,
      text: "Molt bona.",
      rating: 11
    )

    assert_not comment.valid?
    assert_includes comment.errors[:rating], "is not included in the list"
  end

  test "allows only one review per user and recipe" do
    user = create_user("comment_unique")
    recipe = create_recipe(user, "unique")

    Comment.create!(
      user: user,
      recipe: recipe,
      text: "Primer comentari",
      rating: 8
    )

    duplicate = Comment.new(
      user: user,
      recipe: recipe,
      text: "Segon comentari",
      rating: 9
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end
end
