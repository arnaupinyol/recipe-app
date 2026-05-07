require "test_helper"

class StepsTest < ActionDispatch::IntegrationTest
  def create_user_and_recipe(username:, email:, title:)
    user = User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
    recipe = Recipe.create!(
      user: user,
      title: title,
      description: "Recipe description",
      preparation_time_minutes: 20,
      difficulty: 2,
      servings: 2
    )

    [ user, recipe ]
  end

  test "lists steps" do
    _user_1, recipe_1 = create_user_and_recipe(username: "step_owner_1", email: "step.owner.1@example.com", title: "Soup")
    _user_2, recipe_2 = create_user_and_recipe(username: "step_owner_2", email: "step.owner.2@example.com", title: "Cake")

    Step.create!(recipe: recipe_1, description: "Boil water", order_number: 1, timer_seconds: 300)
    Step.create!(recipe: recipe_2, description: "Mix batter", order_number: 1)

    get "/api/steps"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["steps"].length
    assert_equal [ "Soup", "Cake" ], response_body["steps"].map { |step| step["recipe_title"] }
  end

  test "shows a step" do
    _user, recipe = create_user_and_recipe(username: "step_show_owner", email: "step.show.owner@example.com", title: "Bread")
    step = Step.create!(recipe: recipe, description: "Bake dough", order_number: 2, timer_seconds: 1800)

    get "/api/steps/#{step.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bake dough", response_body.dig("step", "description")
    assert_equal "Bread", response_body.dig("step", "recipe_title")
  end

  test "creates a step" do
    _user, recipe = create_user_and_recipe(username: "step_create_owner", email: "step.create.owner@example.com", title: "Pizza")

    post "/api/steps", params: {
      step: {
        recipe_id: recipe.id,
        description: "Add toppings",
        order_number: 1,
        timer_seconds: 120
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal "Add toppings", response_body.dig("step", "description")
    assert_equal recipe.id, response_body.dig("step", "recipe_id")
  end

  test "updates a step" do
    _user, recipe = create_user_and_recipe(username: "step_update_owner", email: "step.update.owner@example.com", title: "Rice")
    step = Step.create!(recipe: recipe, description: "Cook rice", order_number: 1, timer_seconds: 600)

    patch "/api/steps/#{step.id}", params: {
      step: {
        description: "Cook rice gently",
        timer_seconds: 900
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Cook rice gently", response_body.dig("step", "description")
    assert_equal 900, response_body.dig("step", "timer_seconds")
  end

  test "deletes a step" do
    _user, recipe = create_user_and_recipe(username: "step_delete_owner", email: "step.delete.owner@example.com", title: "Tea")
    step = Step.create!(recipe: recipe, description: "Pour tea", order_number: 1)

    delete "/api/steps/#{step.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Step deleted", response_body["message"]
    assert_not Step.exists?(step.id)
  end

  test "returns not found for a missing step" do
    get "/api/steps/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Step not found", response_body.dig("error", "message")
  end

  test "returns validation errors when step is invalid" do
    _user, recipe = create_user_and_recipe(username: "step_invalid_owner", email: "step.invalid.owner@example.com", title: "Pasta")

    post "/api/steps", params: {
      step: {
        recipe_id: recipe.id,
        description: "",
        order_number: 0
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Step creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "description").present?
    assert response_body.dig("error", "details", "order_number").present?
  end

  test "returns validation errors when recipe id is invalid" do
    post "/api/steps", params: {
      step: {
        recipe_id: 999999,
        description: "Missing recipe",
        order_number: 1
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Step creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "recipe_id")
  end
end
