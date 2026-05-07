require "test_helper"

class RecipeSubrecipesTest < ActionDispatch::IntegrationTest
  def create_recipe_for(username:, email:, title:)
    user = User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )

    Recipe.create!(
      user: user,
      title: title,
      description: "Recipe description",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 2,
      can_be_ingredient: true
    )
  end

  test "lists recipe subrecipes" do
    recipe_1 = create_recipe_for(username: "rs_owner_1", email: "rs.owner.1@example.com", title: "Main dish")
    recipe_2 = create_recipe_for(username: "rs_owner_2", email: "rs.owner.2@example.com", title: "Sauce")
    subrecipe_1 = create_recipe_for(username: "rs_owner_3", email: "rs.owner.3@example.com", title: "Stock")
    subrecipe_2 = create_recipe_for(username: "rs_owner_4", email: "rs.owner.4@example.com", title: "Cream")

    RecipeSubrecipe.create!(recipe: recipe_1, subrecipe: subrecipe_1, quantity: 1, unit_type: :units)
    RecipeSubrecipe.create!(recipe: recipe_2, subrecipe: subrecipe_2, quantity: 200, unit_type: :ml)

    get "/api/recipe_subrecipes"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["recipe_subrecipes"].length
  end

  test "shows a recipe subrecipe" do
    recipe = create_recipe_for(username: "rs_show_owner", email: "rs.show.owner@example.com", title: "Lasagna")
    subrecipe = create_recipe_for(username: "rs_show_sub", email: "rs.show.sub@example.com", title: "Bechamel")
    recipe_subrecipe = RecipeSubrecipe.create!(recipe: recipe, subrecipe: subrecipe, quantity: 300, unit_type: :ml)

    get "/api/recipe_subrecipes/#{recipe_subrecipe.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Lasagna", response_body.dig("recipe_subrecipe", "recipe_title")
    assert_equal "Bechamel", response_body.dig("recipe_subrecipe", "subrecipe_title")
  end

  test "creates a recipe subrecipe" do
    recipe = create_recipe_for(username: "rs_create_owner", email: "rs.create.owner@example.com", title: "Burger")
    subrecipe = create_recipe_for(username: "rs_create_sub", email: "rs.create.sub@example.com", title: "Special sauce")

    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: recipe.id,
        subrecipe_id: subrecipe.id,
        quantity: 1,
        unit_type: "units",
        notes: "Prepared before"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal recipe.id, response_body.dig("recipe_subrecipe", "recipe_id")
    assert_equal subrecipe.id, response_body.dig("recipe_subrecipe", "subrecipe_id")
  end

  test "updates a recipe subrecipe" do
    recipe = create_recipe_for(username: "rs_update_owner", email: "rs.update.owner@example.com", title: "Pasta bake")
    subrecipe = create_recipe_for(username: "rs_update_sub", email: "rs.update.sub@example.com", title: "Tomato sauce")
    recipe_subrecipe = RecipeSubrecipe.create!(recipe: recipe, subrecipe: subrecipe, quantity: 1, unit_type: :units)

    patch "/api/recipe_subrecipes/#{recipe_subrecipe.id}", params: {
      recipe_subrecipe: {
        quantity: 2,
        notes: "Double batch"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Double batch", response_body.dig("recipe_subrecipe", "notes")
    assert_equal 2, response_body.dig("recipe_subrecipe", "quantity").to_i
  end

  test "deletes a recipe subrecipe" do
    recipe = create_recipe_for(username: "rs_delete_owner", email: "rs.delete.owner@example.com", title: "Soup")
    subrecipe = create_recipe_for(username: "rs_delete_sub", email: "rs.delete.sub@example.com", title: "Broth")
    recipe_subrecipe = RecipeSubrecipe.create!(recipe: recipe, subrecipe: subrecipe, quantity: 1, unit_type: :units)

    delete "/api/recipe_subrecipes/#{recipe_subrecipe.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Recipe subrecipe deleted", response_body["message"]
    assert_not RecipeSubrecipe.exists?(recipe_subrecipe.id)
  end

  test "returns not found for a missing recipe subrecipe" do
    get "/api/recipe_subrecipes/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Recipe subrecipe not found", response_body.dig("error", "message")
  end

  test "returns validation errors when recipe subrecipe is invalid" do
    recipe = create_recipe_for(username: "rs_invalid_owner", email: "rs.invalid.owner@example.com", title: "Cake")
    subrecipe = create_recipe_for(username: "rs_invalid_sub", email: "rs.invalid.sub@example.com", title: "Frosting")

    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: recipe.id,
        subrecipe_id: subrecipe.id,
        quantity: 0,
        unit_type: "grams"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe subrecipe creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "quantity").present?
  end

  test "returns validation errors when recipe subrecipe relations are invalid" do
    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: 999999,
        subrecipe_id: 999998,
        quantity: 1,
        unit_type: "units"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe subrecipe creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "recipe_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "subrecipe_id")
  end

  test "returns validation errors when recipe and subrecipe are the same" do
    recipe = create_recipe_for(username: "rs_same_owner", email: "rs.same.owner@example.com", title: "Self sauce")

    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: recipe.id,
        subrecipe_id: recipe.id,
        quantity: 1,
        unit_type: "units"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Recipe subrecipe creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "subrecipe_id").present?
  end
end
