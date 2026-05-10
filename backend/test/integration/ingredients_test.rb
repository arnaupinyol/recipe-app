require "test_helper"

class IngredientsTest < ActionDispatch::IntegrationTest
  test "lists ingredients" do
    Ingredient.create!(name: "Tomata", optional_description: "Madura")
    Ingredient.create!(name: "Alfabrega", optional_description: "Fresca")

    get "/api/ingredients"

    assert_response :success
    assert_equal [ "Alfabrega", "Tomata" ], response_json["ingredients"].map { |ingredient| ingredient["name"] }
  end

  test "shows an ingredient with allergies" do
    allergy = Allergy.create!(name: "Gluten")
    ingredient = Ingredient.create!(name: "Farina", optional_description: "De blat")
    ingredient.allergies << allergy

    get "/api/ingredients/#{ingredient.id}"

    assert_response :success
    assert_equal [ allergy.id ], response_json.dig("ingredient", "allergy_ids")
  end

  test "creates an ingredient only for staff" do
    admin = create_user(username: "ingredient_admin", email: "ingredient.admin@example.com", role: :admin)
    allergy_1 = Allergy.create!(name: "Lactosa")
    allergy_2 = Allergy.create!(name: "Soja")

    post "/api/ingredients", params: {
      ingredient: {
        name: "Iogurt",
        image_url: "https://example.com/iogurt.png",
        optional_description: "Natural",
        allergy_ids: [ allergy_1.id, allergy_2.id ]
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :created
    assert_equal [ "Lactosa", "Soja" ], response_json.dig("ingredient", "allergies").map { |item| item["name"] }
  end

  test "rejects ingredient creation for non staff users" do
    user = create_user(username: "ingredient_user", email: "ingredient.user@example.com")

    post "/api/ingredients", params: {
      ingredient: {
        name: "Iogurt"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "updates an ingredient" do
    admin = create_user(username: "ingredient_admin_update", email: "ingredient.admin.update@example.com", role: :admin)
    allergy = Allergy.create!(name: "Fruits secs")
    ingredient = Ingredient.create!(name: "Crema", optional_description: "Suau")

    patch "/api/ingredients/#{ingredient.id}", params: {
      ingredient: {
        optional_description: "Suau i espessa",
        allergy_ids: [ allergy.id ]
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :success
    assert_equal "Suau i espessa", response_json.dig("ingredient", "optional_description")
  end

  test "deletes an ingredient without dependent usages" do
    admin = create_user(username: "ingredient_admin_delete", email: "ingredient.admin.delete@example.com", role: :admin)
    ingredient = Ingredient.create!(name: "Canyella")

    delete "/api/ingredients/#{ingredient.id}", headers: auth_headers_for(admin)

    assert_response :success
    assert_equal "Ingredient deleted", response_json["message"]
  end
end
