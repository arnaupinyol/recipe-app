require "test_helper"

class AllergiesTest < ActionDispatch::IntegrationTest
  test "lists allergies" do
    Allergy.create!(name: "Lactosa")
    Allergy.create!(name: "Gluten")

    get "/api/allergies"

    assert_response :success
    assert_equal [ "Gluten", "Lactosa" ], response_json["allergies"].map { |allergy| allergy["name"] }
  end

  test "shows an allergy with ingredients" do
    ingredient = Ingredient.create!(name: "Llet")
    allergy = Allergy.create!(name: "Lactosa")
    allergy.ingredients << ingredient

    get "/api/allergies/#{allergy.id}"

    assert_response :success
    assert_equal [ ingredient.id ], response_json.dig("allergy", "ingredient_ids")
  end

  test "creates an allergy only for staff" do
    admin = create_user(username: "allergy_admin", email: "allergy.admin@example.com", role: :admin)
    ingredient_1 = Ingredient.create!(name: "Llet")
    ingredient_2 = Ingredient.create!(name: "Mantega")

    post "/api/allergies", params: {
      allergy: {
        name: "Lactis",
        ingredient_ids: [ ingredient_1.id, ingredient_2.id ]
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :created
    assert_equal "Lactis", response_json.dig("allergy", "name")
  end

  test "rejects allergy creation for non staff users" do
    user = create_user(username: "allergy_user", email: "allergy.user@example.com")

    post "/api/allergies", params: {
      allergy: {
        name: "Lactis"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "updates an allergy" do
    admin = create_user(username: "allergy_admin_update", email: "allergy.admin.update@example.com", role: :admin)
    ingredient = Ingredient.create!(name: "Cacauet")
    allergy = Allergy.create!(name: "Fruits secs")

    patch "/api/allergies/#{allergy.id}", params: {
      allergy: {
        ingredient_ids: [ ingredient.id ]
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :success
    assert_equal [ ingredient.id ], response_json.dig("allergy", "ingredient_ids")
  end

  test "deletes an allergy without associations" do
    admin = create_user(username: "allergy_admin_delete", email: "allergy.admin.delete@example.com", role: :admin)
    allergy = Allergy.create!(name: "Api")

    delete "/api/allergies/#{allergy.id}", headers: auth_headers_for(admin)

    assert_response :success
    assert_equal "Allergy deleted", response_json["message"]
  end
end
