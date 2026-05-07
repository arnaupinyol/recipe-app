require "test_helper"

class IngredientsTest < ActionDispatch::IntegrationTest
  test "lists ingredients" do
    Ingredient.create!(name: "Tomata", optional_description: "Madura")
    Ingredient.create!(name: "Alfàbrega", optional_description: "Fresca")

    get "/api/ingredients"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ "Alfàbrega", "Tomata" ], response_body["ingredients"].map { |ingredient| ingredient["name"] }
  end

  test "shows an ingredient with allergies" do
    allergy = Allergy.create!(name: "Gluten")
    ingredient = Ingredient.create!(name: "Farina", optional_description: "De blat")
    ingredient.allergies << allergy

    get "/api/ingredients/#{ingredient.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Farina", response_body.dig("ingredient", "name")
    assert_equal [ allergy.id ], response_body.dig("ingredient", "allergy_ids")
    assert_equal [ "Gluten" ], response_body.dig("ingredient", "allergies").map { |item| item["name"] }
  end

  test "creates an ingredient" do
    allergy_1 = Allergy.create!(name: "Lactosa")
    allergy_2 = Allergy.create!(name: "Soja")

    post "/api/ingredients", params: {
      ingredient: {
        name: "Iogurt",
        image_url: "https://example.com/iogurt.png",
        optional_description: "Natural",
        allergy_ids: [ allergy_1.id, allergy_2.id ]
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Iogurt", response_body.dig("ingredient", "name")
    assert_equal [ "Lactosa", "Soja" ], response_body.dig("ingredient", "allergies").map { |item| item["name"] }
  end

  test "updates an ingredient" do
    allergy = Allergy.create!(name: "Fruits secs")
    ingredient = Ingredient.create!(name: "Crema", optional_description: "Suau")

    patch "/api/ingredients/#{ingredient.id}", params: {
      ingredient: {
        optional_description: "Suau i espessa",
        allergy_ids: [ allergy.id ]
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Suau i espessa", response_body.dig("ingredient", "optional_description")
    assert_equal [ allergy.id ], response_body.dig("ingredient", "allergy_ids")
    assert_equal "Suau i espessa", ingredient.reload.optional_description
  end

  test "deletes an ingredient without dependent usages" do
    ingredient = Ingredient.create!(name: "Canyella")

    delete "/api/ingredients/#{ingredient.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Ingredient deleted", response_body["message"]
    assert_not Ingredient.exists?(ingredient.id)
  end

  test "does not delete an ingredient associated with a recipe" do
    user = User.create!(
      username: "ingredient_owner",
      email: "ingredient.owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    ingredient = Ingredient.create!(name: "Oli")
    recipe = Recipe.create!(
      user: user,
      title: "Pa amb tomàquet",
      description: "Simple",
      preparation_time_minutes: 5,
      difficulty: 1,
      servings: 1
    )
    RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 1, unit_type: :units)

    delete "/api/ingredients/#{ingredient.id}"

    assert_response :conflict

    response_body = JSON.parse(response.body)
    assert_equal "Ingredient cannot be deleted because it is associated with recipes or shopping lists", response_body.dig("error", "message")
    assert Ingredient.exists?(ingredient.id)
  end

  test "returns not found for a missing ingredient" do
    get "/api/ingredients/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Ingredient not found", response_body.dig("error", "message")
  end

  test "returns validation errors when ingredient is invalid" do
    post "/api/ingredients", params: {
      ingredient: {
        name: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Ingredient creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "name").present?
  end
end
