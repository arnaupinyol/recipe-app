require "test_helper"

class CategoriesTest < ActionDispatch::IntegrationTest
  test "lists categories" do
    Category.create!(name: "Postres", description: "Dolcos i pastissos")
    Category.create!(name: "Amanides", description: "Opcions fresques")

    get "/api/categories"

    assert_response :success
    assert_equal [ "Amanides", "Postres" ], response_json["categories"].map { |category| category["name"] }
  end

  test "shows a category" do
    category = Category.create!(name: "Sopes", description: "Per dies freds")

    get "/api/categories/#{category.id}"

    assert_response :success
    assert_equal "Sopes", response_json.dig("category", "name")
  end

  test "creates a category only for staff" do
    admin = create_user(username: "category_admin", email: "category.admin@example.com", role: :admin)

    post "/api/categories", params: {
      category: {
        name: "Esmorzars",
        description: "Per comencar el dia"
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :created
    assert_equal "Esmorzars", response_json.dig("category", "name")
  end

  test "rejects category creation for non staff users" do
    user = create_user(username: "category_user", email: "category.user@example.com")

    post "/api/categories", params: {
      category: {
        name: "Esmorzars"
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :forbidden
    assert_equal "Forbidden", response_json.dig("error", "message")
  end

  test "updates a category" do
    admin = create_user(username: "category_admin_update", email: "category.admin.update@example.com", role: :admin)
    category = Category.create!(name: "Begudes", description: "Fredes")

    patch "/api/categories/#{category.id}", params: {
      category: {
        description: "Fredes i calentes"
      }
    }, headers: auth_headers_for(admin), as: :json

    assert_response :success
    assert_equal "Fredes i calentes", response_json.dig("category", "description")
  end

  test "deletes a category without recipes" do
    admin = create_user(username: "category_admin_delete", email: "category.admin.delete@example.com", role: :admin)
    category = Category.create!(name: "Temporada", description: "Productes del moment")

    delete "/api/categories/#{category.id}", headers: auth_headers_for(admin)

    assert_response :success
    assert_equal "Category deleted", response_json["message"]
    assert_not Category.exists?(category.id)
  end
end
