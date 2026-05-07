require "test_helper"

class UtensilsTest < ActionDispatch::IntegrationTest
  test "lists utensils" do
    Utensil.create!(name: "Paella")
    Utensil.create!(name: "Batedora")

    get "/api/utensils"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ "Batedora", "Paella" ], response_body["utensils"].map { |utensil| utensil["name"] }
  end

  test "shows a utensil with recipes" do
    user = User.create!(
      username: "utensil_show_owner",
      email: "utensil.show.owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    recipe = Recipe.create!(
      user: user,
      title: "Truita",
      description: "Rapida",
      preparation_time_minutes: 10,
      difficulty: 1,
      servings: 2
    )
    utensil = Utensil.create!(name: "Paella")
    utensil.recipes << recipe

    get "/api/utensils/#{utensil.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Paella", response_body.dig("utensil", "name")
    assert_equal [ recipe.id ], response_body.dig("utensil", "recipe_ids")
    assert_equal [ "Truita" ], response_body.dig("utensil", "recipes").map { |item| item["title"] }
  end

  test "creates a utensil" do
    user = User.create!(
      username: "utensil_create_owner",
      email: "utensil.create.owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    recipe = Recipe.create!(
      user: user,
      title: "Sopa",
      description: "Calenta",
      preparation_time_minutes: 25,
      difficulty: 2,
      servings: 4
    )

    post "/api/utensils", params: {
      utensil: {
        name: "Casso",
        recipe_ids: [ recipe.id ]
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Casso", response_body.dig("utensil", "name")
    assert_equal [ "Sopa" ], response_body.dig("utensil", "recipes").map { |item| item["title"] }
  end

  test "updates a utensil" do
    user = User.create!(
      username: "utensil_update_owner",
      email: "utensil.update.owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    recipe = Recipe.create!(
      user: user,
      title: "Pure",
      description: "Suau",
      preparation_time_minutes: 15,
      difficulty: 1,
      servings: 3
    )
    utensil = Utensil.create!(name: "Morter")

    patch "/api/utensils/#{utensil.id}", params: {
      utensil: {
        recipe_ids: [ recipe.id ]
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ recipe.id ], response_body.dig("utensil", "recipe_ids")
    assert_equal [ recipe.id ], utensil.reload.recipe_ids
  end

  test "deletes a utensil without recipes" do
    utensil = Utensil.create!(name: "Escumadora")

    delete "/api/utensils/#{utensil.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Utensil deleted", response_body["message"]
    assert_not Utensil.exists?(utensil.id)
  end

  test "does not delete a utensil associated with recipes" do
    user = User.create!(
      username: "utensil_delete_owner",
      email: "utensil.delete.owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    recipe = Recipe.create!(
      user: user,
      title: "Arròs",
      description: "Sec",
      preparation_time_minutes: 30,
      difficulty: 3,
      servings: 2
    )
    utensil = Utensil.create!(name: "Cassola")
    utensil.recipes << recipe

    delete "/api/utensils/#{utensil.id}"

    assert_response :conflict

    response_body = JSON.parse(response.body)
    assert_equal "Utensil cannot be deleted because it is associated with recipes", response_body.dig("error", "message")
    assert Utensil.exists?(utensil.id)
  end

  test "returns not found for a missing utensil" do
    get "/api/utensils/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Utensil not found", response_body.dig("error", "message")
  end

  test "returns validation errors when utensil is invalid" do
    post "/api/utensils", params: {
      utensil: {
        name: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Utensil creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "name").present?
  end

  test "returns validation errors when recipe ids are invalid" do
    post "/api/utensils", params: {
      utensil: {
        name: "Colador",
        recipe_ids: [ 999999 ]
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Utensil creation failed", response_body.dig("error", "message")
    assert_equal [ "contain invalid values" ], response_body.dig("error", "details", "recipe_ids")
  end
end
