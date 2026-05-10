require "test_helper"

class UtensilsTest < ActionDispatch::IntegrationTest
  test "lists utensils with only visible recipes" do
    owner = create_user(username: "utensil_owner", email: "utensil.owner@example.com")
    other_owner = create_user(username: "utensil_other_owner", email: "utensil.other.owner@example.com")
    public_recipe = create_recipe_for(user: owner, title: "Truita")
    private_recipe = create_recipe_for(user: other_owner, title: "Secret", visibility: :private_recipe)
    utensil = Utensil.create!(name: "Paella")
    utensil.recipes << public_recipe
    utensil.recipes << private_recipe

    get "/api/utensils"

    assert_response :success
    assert_equal [ public_recipe.id ], response_json.dig("utensils", 0, "recipe_ids")
  end

  test "shows a utensil with only visible recipes" do
    owner = create_user(username: "utensil_show_owner", email: "utensil.show.owner@example.com")
    recipe = create_recipe_for(user: owner, title: "Truita")
    utensil = Utensil.create!(name: "Paella")
    utensil.recipes << recipe

    get "/api/utensils/#{utensil.id}"

    assert_response :success
    assert_equal [ recipe.id ], response_json.dig("utensil", "recipe_ids")
    assert_equal [ "Truita" ], response_json.dig("utensil", "recipes").map { |item| item["title"] }
  end

  test "creates a utensil only for staff" do
    admin = create_user(username: "utensil_admin", email: "utensil.admin@example.com", role: :admin)

    post "/api/utensils", params: {
      utensil: {
        name: "Casso",
        recipe_ids: [ 999999 ]
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :created
    assert_equal "Casso", response_json.dig("utensil", "name")
    assert_equal [], response_json.dig("utensil", "recipe_ids")
  end

  test "rejects utensil creation for non staff users" do
    user = create_user(username: "utensil_user", email: "utensil.user@example.com")

    post "/api/utensils", params: {
      utensil: {
        name: "Casso"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "updates a utensil" do
    admin = create_user(username: "utensil_admin_update", email: "utensil.admin.update@example.com", role: :admin)
    utensil = Utensil.create!(name: "Morter")

    patch "/api/utensils/#{utensil.id}", params: {
      utensil: {
        name: "Morter gran"
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :success
    assert_equal "Morter gran", response_json.dig("utensil", "name")
  end

  test "deletes a utensil without recipes" do
    admin = create_user(username: "utensil_admin_delete", email: "utensil.admin.delete@example.com", role: :admin)
    utensil = Utensil.create!(name: "Escumadora")

    delete "/api/utensils/#{utensil.id}", headers: auth_headers_for(admin)

    assert_response :success
    assert_equal "Utensil deleted", response_json["message"]
  end
end
