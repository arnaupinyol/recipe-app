require "test_helper"

class RecipeSubrecipesTest < ActionDispatch::IntegrationTest
  def build_subrecipe(user:, title:, visibility: :public_recipe)
    create_recipe_for(user: user, title: title, visibility: visibility, can_be_ingredient: true)
  end

  test "lists recipe subrecipes only when both recipes are visible" do
    owner = create_user(username: "rs_owner_1", email: "rs.owner.1@example.com")
    other_owner = create_user(username: "rs_owner_2", email: "rs.owner.2@example.com")
    recipe = build_subrecipe(user: owner, title: "Main dish")
    visible_subrecipe = build_subrecipe(user: owner, title: "Stock")
    hidden_recipe = build_subrecipe(user: other_owner, title: "Secret main", visibility: :private_recipe)
    hidden_subrecipe = build_subrecipe(user: other_owner, title: "Secret sauce", visibility: :private_recipe)

    RecipeSubrecipe.create!(recipe: recipe, subrecipe: visible_subrecipe, quantity: 1, unit_type: :units)
    RecipeSubrecipe.create!(recipe: hidden_recipe, subrecipe: hidden_subrecipe, quantity: 200, unit_type: :ml)

    get "/api/recipe_subrecipes"

    assert_response :success
    assert_equal 1, response_json["recipe_subrecipes"].length
  end

  test "shows a recipe subrecipe" do
    user = create_user(username: "rs_show_owner", email: "rs.show.owner@example.com")
    recipe = build_subrecipe(user: user, title: "Lasagna")
    subrecipe = build_subrecipe(user: user, title: "Bechamel")
    recipe_subrecipe = RecipeSubrecipe.create!(recipe: recipe, subrecipe: subrecipe, quantity: 300, unit_type: :ml)

    get "/api/recipe_subrecipes/#{recipe_subrecipe.id}"

    assert_response :success
    assert_equal "Lasagna", response_json.dig("recipe_subrecipe", "recipe_title")
    assert_equal "Bechamel", response_json.dig("recipe_subrecipe", "subrecipe_title")
  end

  test "creates a recipe subrecipe for an owned recipe and visible subrecipe" do
    user = create_user(username: "rs_create_owner", email: "rs.create.owner@example.com")
    recipe = build_subrecipe(user: user, title: "Burger")
    subrecipe = build_subrecipe(user: user, title: "Special sauce")

    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: recipe.id,
        subrecipe_id: subrecipe.id,
        quantity: 1,
        unit_type: "units",
        notes: "Prepared before"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created
    assert_equal recipe.id, response_json.dig("recipe_subrecipe", "recipe_id")
    assert_equal subrecipe.id, response_json.dig("recipe_subrecipe", "subrecipe_id")
  end

  test "rejects a hidden subrecipe from another user" do
    user = create_user(username: "rs_intruder", email: "rs.intruder@example.com")
    owner = create_user(username: "rs_real_owner", email: "rs.real.owner@example.com")
    recipe = build_subrecipe(user: user, title: "Burger")
    hidden_subrecipe = build_subrecipe(user: owner, title: "Secret sauce", visibility: :private_recipe)

    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: recipe.id,
        subrecipe_id: hidden_subrecipe.id,
        quantity: 1,
        unit_type: "units"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "subrecipe_id")
  end

  test "updates a recipe subrecipe only for its owner" do
    user = create_user(username: "rs_update_owner", email: "rs.update.owner@example.com")
    recipe = build_subrecipe(user: user, title: "Pasta bake")
    subrecipe = build_subrecipe(user: user, title: "Tomato sauce")
    recipe_subrecipe = RecipeSubrecipe.create!(recipe: recipe, subrecipe: subrecipe, quantity: 1, unit_type: :units)

    patch "/api/recipe_subrecipes/#{recipe_subrecipe.id}", params: {
      recipe_subrecipe: {
        quantity: 2,
        notes: "Double batch"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success
    assert_equal "Double batch", response_json.dig("recipe_subrecipe", "notes")
    assert_equal 2, response_json.dig("recipe_subrecipe", "quantity").to_i
  end

  test "deletes a recipe subrecipe" do
    user = create_user(username: "rs_delete_owner", email: "rs.delete.owner@example.com")
    recipe = build_subrecipe(user: user, title: "Soup")
    subrecipe = build_subrecipe(user: user, title: "Broth")
    recipe_subrecipe = RecipeSubrecipe.create!(recipe: recipe, subrecipe: subrecipe, quantity: 1, unit_type: :units)

    delete "/api/recipe_subrecipes/#{recipe_subrecipe.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Recipe subrecipe deleted", response_json["message"]
    assert_not RecipeSubrecipe.exists?(recipe_subrecipe.id)
  end

  test "returns validation errors when recipe and subrecipe are the same" do
    user = create_user(username: "rs_same_owner", email: "rs.same.owner@example.com")
    recipe = build_subrecipe(user: user, title: "Self sauce")

    post "/api/recipe_subrecipes", params: {
      recipe_subrecipe: {
        recipe_id: recipe.id,
        subrecipe_id: recipe.id,
        quantity: 1,
        unit_type: "units"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal "Recipe subrecipe creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "subrecipe_id").present?
  end
end
