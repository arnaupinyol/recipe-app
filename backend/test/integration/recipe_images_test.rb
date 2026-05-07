require "test_helper"

class RecipeImagesTest < ActionDispatch::IntegrationTest
  def create_recipe_for(title:)
    user = User.create!(
      username: "recipe_image_#{title.downcase}",
      email: "recipe.image.#{title.downcase}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    Recipe.create!(
      user: user,
      title: title,
      description: "Recipe description",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 2
    )
  end

  test "lists recipe images" do
    recipe_1 = create_recipe_for(title: "Soup")
    recipe_2 = create_recipe_for(title: "Cake")

    RecipeImage.create!(recipe: recipe_1, url: "https://example.com/soup.jpg")
    RecipeImage.create!(recipe: recipe_2, url: "https://example.com/cake.jpg")

    get "/api/recipe_images"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["recipe_images"].length
  end

  test "shows a recipe image" do
    recipe = create_recipe_for(title: "Bread")
    recipe_image = RecipeImage.create!(recipe: recipe, url: "https://example.com/bread.jpg")

    get "/api/recipe_images/#{recipe_image.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bread", response_body.dig("recipe_image", "recipe_title")
  end

  test "creates a recipe image" do
    recipe = create_recipe_for(title: "Pizza")

    post "/api/recipe_images", params: {
      recipe_image: {
        recipe_id: recipe.id,
        url: "https://example.com/pizza.jpg"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal recipe.id, response_body.dig("recipe_image", "recipe_id")
  end

  test "updates a recipe image" do
    recipe = create_recipe_for(title: "Rice")
    recipe_image = RecipeImage.create!(recipe: recipe, url: "https://example.com/rice-old.jpg")

    patch "/api/recipe_images/#{recipe_image.id}", params: {
      recipe_image: {
        url: "https://example.com/rice-new.jpg"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "https://example.com/rice-new.jpg", response_body.dig("recipe_image", "url")
  end

  test "deletes a recipe image" do
    recipe = create_recipe_for(title: "Tea")
    recipe_image = RecipeImage.create!(recipe: recipe, url: "https://example.com/tea.jpg")

    delete "/api/recipe_images/#{recipe_image.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Recipe image deleted", response_body["message"]
    assert_not RecipeImage.exists?(recipe_image.id)
  end

  test "returns not found for a missing recipe image" do
    get "/api/recipe_images/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Recipe image not found", response_body.dig("error", "message")
  end

  test "returns validation errors when recipe image is invalid" do
    recipe = create_recipe_for(title: "Pasta")

    post "/api/recipe_images", params: {
      recipe_image: {
        recipe_id: recipe.id,
        url: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe image creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "url").present?
  end

  test "returns validation errors when recipe id is invalid" do
    post "/api/recipe_images", params: {
      recipe_image: {
        recipe_id: 999999,
        url: "https://example.com/missing-recipe.jpg"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe image creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "recipe_id")
  end
end
