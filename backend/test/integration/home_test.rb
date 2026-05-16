require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "lists visible recipes with home details" do
    user = create_user(username: "home_owner", email: "home.owner@example.com")
    viewer = create_user(username: "home_viewer", email: "home.viewer@example.com")
    category = Category.create!(name: "Catalana")
    ingredient = Ingredient.create!(name: "Patata")
    recipe = create_recipe_for(user: user, title: "Patates d'Olot", preparation_time_minutes: 60, servings: 4)
    attach_test_image(ingredient)
    attach_test_image(RecipeImage.new(recipe: recipe))

    recipe.categories << category
    RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 4, unit_type: :units, notes: "Kennebec mitjanes")
    Step.create!(recipe: recipe, description: "Prepara el farcit", order_number: 1)
    UserRecipeLike.create!(user: viewer, recipe: recipe)
    UserSavedRecipe.create!(user: viewer, recipe: recipe)

    get "/api/home", headers: auth_headers_for(viewer)

    assert_response :success

    home_recipe = response_json["recipes"].first
    assert_equal "Patates d'Olot", home_recipe["title"]
    assert_equal [ "Catalana" ], home_recipe["categories"].map { |item| item["name"] }
    assert_equal [ "Patata" ], home_recipe["ingredients"].map { |item| item["name"] }
    assert home_recipe["image_urls"].first.start_with?("http://www.example.com/rails/active_storage/")
    assert home_recipe["ingredients"].first["image_url"].start_with?("http://www.example.com/rails/active_storage/")
    assert_equal [ "Prepara el farcit" ], home_recipe["steps"].map { |item| item["description"] }
    assert_equal true, home_recipe["liked_by_current_user"]
    assert_equal true, home_recipe["saved_by_current_user"]
  end

  test "following feed only returns recipes from followed users" do
    viewer = create_user(username: "home_follow_viewer", email: "home.follow.viewer@example.com")
    followed = create_user(username: "home_followed", email: "home.followed@example.com")
    not_followed = create_user(username: "home_not_followed", email: "home.not.followed@example.com")
    followed_recipe = create_recipe_for(user: followed, title: "Followed Recipe")
    create_recipe_for(user: not_followed, title: "Other Recipe")

    Follow.create!(follower: viewer, followed: followed)

    get "/api/home", params: { feed: "following" }, headers: auth_headers_for(viewer)

    assert_response :success
    assert_equal [ followed_recipe.id ], response_json["recipes"].map { |recipe| recipe["id"] }
  end

  test "following feed is empty without authentication" do
    user = create_user(username: "home_anon_owner", email: "home.anon.owner@example.com")
    create_recipe_for(user: user, title: "Public Recipe")

    get "/api/home", params: { feed: "following" }

    assert_response :success
    assert_equal [], response_json["recipes"]
  end
end
