require "test_helper"

class StepsTest < ActionDispatch::IntegrationTest
  test "lists steps only for visible recipes" do
    owner = create_user(username: "step_owner_1", email: "step.owner.1@example.com")
    other_owner = create_user(username: "step_owner_2", email: "step.owner.2@example.com")
    recipe_1 = create_recipe_for(user: owner, title: "Soup")
    recipe_2 = create_recipe_for(user: other_owner, title: "Cake", visibility: :private_recipe)

    Step.create!(recipe: recipe_1, description: "Boil water", order_number: 1, timer_seconds: 300)
    Step.create!(recipe: recipe_2, description: "Mix batter", order_number: 1)

    get "/api/steps"

    assert_response :success
    assert_equal [ "Soup" ], response_json["steps"].map { |step| step["recipe_title"] }
  end

  test "shows a step for a visible recipe" do
    user = create_user(username: "step_show_owner", email: "step.show.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Bread")
    step = Step.create!(recipe: recipe, description: "Bake dough", order_number: 2, timer_seconds: 1800)

    get "/api/steps/#{step.id}"

    assert_response :success
    assert_equal "Bake dough", response_json.dig("step", "description")
    assert_equal "Bread", response_json.dig("step", "recipe_title")
  end

  test "creates a step only for an owned recipe" do
    user = create_user(username: "step_create_owner", email: "step.create.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pizza")

    post "/api/steps", params: {
      step: {
        recipe_id: recipe.id,
        description: "Add toppings",
        order_number: 1,
        timer_seconds: 120
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :created
    assert_equal "Add toppings", response_json.dig("step", "description")
    assert_equal recipe.id, response_json.dig("step", "recipe_id")
  end

  test "prevents creating a step for another user's recipe" do
    user = create_user(username: "step_intruder", email: "step.intruder@example.com")
    owner = create_user(username: "step_real_owner", email: "step.real.owner@example.com")
    recipe = create_recipe_for(user: owner, title: "Protected")

    post "/api/steps", params: {
      step: {
        recipe_id: recipe.id,
        description: "Hack",
        order_number: 1
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "recipe_id")
  end

  test "updates a step only for its owner" do
    user = create_user(username: "step_update_owner", email: "step.update.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Rice")
    step = Step.create!(recipe: recipe, description: "Cook rice", order_number: 1, timer_seconds: 600)

    patch "/api/steps/#{step.id}", params: {
      step: {
        description: "Cook rice gently",
        timer_seconds: 900
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :success
    assert_equal "Cook rice gently", response_json.dig("step", "description")
    assert_equal 900, response_json.dig("step", "timer_seconds")
  end

  test "deletes a step" do
    user = create_user(username: "step_delete_owner", email: "step.delete.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Tea")
    step = Step.create!(recipe: recipe, description: "Pour tea", order_number: 1)

    delete "/api/steps/#{step.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Step deleted", response_json["message"]
    assert_not Step.exists?(step.id)
  end

  test "returns not found for a hidden step" do
    owner = create_user(username: "step_private_owner", email: "step.private.owner@example.com")
    recipe = create_recipe_for(user: owner, title: "Hidden", visibility: :private_recipe)
    step = Step.create!(recipe: recipe, description: "Secret", order_number: 1)

    get "/api/steps/#{step.id}"

    assert_response :not_found
    assert_equal "Step not found", response_json.dig("error", "message")
  end

  test "returns validation errors when step is invalid" do
    user = create_user(username: "step_invalid_owner", email: "step.invalid.owner@example.com")
    recipe = create_recipe_for(user: user, title: "Pasta")

    post "/api/steps", params: {
      step: {
        recipe_id: recipe.id,
        description: "",
        order_number: 0
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert_equal "Step creation failed", response_json.dig("error", "message")
    assert response_json.dig("error", "details", "description").present?
    assert response_json.dig("error", "details", "order_number").present?
  end
end
