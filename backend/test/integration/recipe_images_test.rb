require "test_helper"

class RecipeImagesTest < ActionDispatch::IntegrationTest
  test "lists recipe images only for visible recipes" do
    owner = create_user(username: "recipe_image_owner_1", email: "recipe.image.owner.1@example.com")
    other_owner = create_user(username: "recipe_image_owner_2", email: "recipe.image.owner.2@example.com")
    recipe_1 = create_recipe_for(user: owner, title: "Soup")
    recipe_2 = create_recipe_for(user: other_owner, title: "Cake", visibility: :private_recipe)

    attach_test_image(RecipeImage.new(recipe: recipe_1))
    attach_test_image(RecipeImage.new(recipe: recipe_2))

    get "/api/recipe_images"

    assert_response :success
    assert_equal 1, response_json["recipe_images"].length
  end

  test "shows a recipe image" do
    user = create_user(username: "recipe_image_show_owner", email: "recipe.image.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    recipe_image = attach_test_image(RecipeImage.new(recipe: recipe))

    get "/api/recipe_images/#{recipe_image.id}"

    assert_response :success
    assert_equal "Bread", response_json.dig("recipe_image", "recipe_title")
  end

  test "creates a recipe image only for an owned recipe" do
    user = create_user(username: "recipe_image_create_owner", email: "recipe.image.create.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pizza")

    post "/api/recipe_images", params: {
      recipe_image: {
        recipe_id: recipe.id,
        image: uploaded_image
      }
    }, headers: auth_headers_for(user)

    assert_response :created
    assert_equal recipe.id, response_json.dig("recipe_image", "recipe_id")
    assert_match %r{\A/rails/active_storage/}, response_json.dig("recipe_image", "url")
  end

  test "updates a recipe image only for its owner" do
    user = create_user(username: "recipe_image_update_owner", email: "recipe.image.update.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Rice")
    recipe_image = attach_test_image(RecipeImage.new(recipe: recipe), filename: "old-test-image.png")

    patch "/api/recipe_images/#{recipe_image.id}", params: {
      recipe_image: {
        image: uploaded_image
      }
    }, headers: auth_headers_for(user)

    assert_response :success
    assert_match %r{\A/rails/active_storage/}, response_json.dig("recipe_image", "url")
  end

  test "deletes a recipe image" do
    user = create_user(username: "recipe_image_delete_owner", email: "recipe.image.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Tea")
    recipe_image = attach_test_image(RecipeImage.new(recipe: recipe))

    delete "/api/recipe_images/#{recipe_image.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Recipe image deleted", response_json["message"]
    assert_not RecipeImage.exists?(recipe_image.id)
  end

  test "returns validation errors when recipe id is not editable" do
    user = create_user(username: "recipe_image_intruder", email: "recipe.image.intruder@example.com")
    owner = create_user(username: "recipe_image_owner_x", email: "recipe.image.owner.x@example.com")
    recipe = create_recipe_for(user: owner, title: "Locked")

    post "/api/recipe_images", params: {
      recipe_image: {
        recipe_id: recipe.id,
        image: uploaded_image
      }
    }, headers: auth_headers_for(user)

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "recipe_id")
  end
end
