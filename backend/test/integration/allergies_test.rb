require "test_helper"

class AllergiesTest < ActionDispatch::IntegrationTest
  test "lists allergies" do
    Allergy.create!(name: "Lactosa")
    Allergy.create!(name: "Gluten")

    get "/api/allergies"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ "Gluten", "Lactosa" ], response_body["allergies"].map { |allergy| allergy["name"] }
  end

  test "shows an allergy with ingredients" do
    ingredient = Ingredient.create!(name: "Llet")
    allergy = Allergy.create!(name: "Lactosa")
    allergy.ingredients << ingredient

    get "/api/allergies/#{allergy.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Lactosa", response_body.dig("allergy", "name")
    assert_equal [ ingredient.id ], response_body.dig("allergy", "ingredient_ids")
    assert_equal [ "Llet" ], response_body.dig("allergy", "ingredients").map { |item| item["name"] }
  end

  test "creates an allergy" do
    ingredient_1 = Ingredient.create!(name: "Llet")
    ingredient_2 = Ingredient.create!(name: "Mantega")

    post "/api/allergies", params: {
      allergy: {
        name: "Lactis",
        ingredient_ids: [ ingredient_1.id, ingredient_2.id ]
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Lactis", response_body.dig("allergy", "name")
    assert_equal [ "Llet", "Mantega" ], response_body.dig("allergy", "ingredients").map { |item| item["name"] }
  end

  test "updates an allergy" do
    ingredient = Ingredient.create!(name: "Cacauet")
    allergy = Allergy.create!(name: "Fruits secs")

    patch "/api/allergies/#{allergy.id}", params: {
      allergy: {
        ingredient_ids: [ ingredient.id ]
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal [ ingredient.id ], response_body.dig("allergy", "ingredient_ids")
    assert_equal [ ingredient.id ], allergy.reload.ingredient_ids
  end

  test "deletes an allergy without associations" do
    allergy = Allergy.create!(name: "Api")

    delete "/api/allergies/#{allergy.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Allergy deleted", response_body["message"]
    assert_not Allergy.exists?(allergy.id)
  end

  test "does not delete an allergy associated with ingredients" do
    ingredient = Ingredient.create!(name: "Ou")
    allergy = Allergy.create!(name: "Ou")
    allergy.ingredients << ingredient

    delete "/api/allergies/#{allergy.id}"

    assert_response :conflict

    response_body = JSON.parse(response.body)
    assert_equal "Allergy cannot be deleted because it is associated with ingredients or users", response_body.dig("error", "message")
    assert Allergy.exists?(allergy.id)
  end

  test "does not delete an allergy associated with users" do
    user = User.create!(
      username: "allergy_user",
      email: "allergy.user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    allergy = Allergy.create!(name: "Marisc")
    user.allergies << allergy

    delete "/api/allergies/#{allergy.id}"

    assert_response :conflict

    response_body = JSON.parse(response.body)
    assert_equal "Allergy cannot be deleted because it is associated with ingredients or users", response_body.dig("error", "message")
    assert Allergy.exists?(allergy.id)
  end

  test "returns not found for a missing allergy" do
    get "/api/allergies/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Allergy not found", response_body.dig("error", "message")
  end

  test "returns validation errors when allergy is invalid" do
    post "/api/allergies", params: {
      allergy: {
        name: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Allergy creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "name").present?
  end
end
