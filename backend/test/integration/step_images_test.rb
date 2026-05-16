require "test_helper"

class StepImagesTest < ActionDispatch::IntegrationTest
  def build_step(user:, title:, visibility: :public_recipe)
    recipe = create_recipe_for(user: user, title: title, visibility: visibility)
    Step.create!(recipe: recipe, description: "Prepare #{title}", order_number: 1)
  end

  test "lists step images only for visible recipes" do
    owner = create_user(username: "step_image_owner_1", email: "step.image.owner.1@example.com")
    other_owner = create_user(username: "step_image_owner_2", email: "step.image.owner.2@example.com")
    step_1 = build_step(user: owner, title: "Soup")
    step_2 = build_step(user: other_owner, title: "Cake", visibility: :private_recipe)

    attach_test_image(StepImage.new(step: step_1))
    attach_test_image(StepImage.new(step: step_2))

    get "/api/step_images"

    assert_response :success
    assert_equal 1, response_json["step_images"].length
  end

  test "shows a step image for a visible recipe" do
    user = create_user(username: "step_image_show_owner", email: "step.image.show.owner@example.com")
    step = build_step(user: user, title: "Bread")
    step_image = attach_test_image(StepImage.new(step: step))

    get "/api/step_images/#{step_image.id}"

    assert_response :success
    assert_equal "Bread", response_json.dig("step_image", "recipe_title")
  end

  test "creates a step image only for an owned step" do
    user = create_user(username: "step_image_create_owner", email: "step.image.create.owner@example.com")
    step = build_step(user: user, title: "Pizza")

    post "/api/step_images", params: {
      step_image: {
        step_id: step.id,
        image: uploaded_image
      }
    }, headers: auth_headers_for(user)

    assert_response :created
    assert_equal step.id, response_json.dig("step_image", "step_id")
    assert_match %r{\A/rails/active_storage/}, response_json.dig("step_image", "url")
  end

  test "updates a step image only for its owner" do
    user = create_user(username: "step_image_update_owner", email: "step.image.update.owner@example.com")
    step = build_step(user: user, title: "Rice")
    step_image = attach_test_image(StepImage.new(step: step), filename: "old-test-image.png")

    patch "/api/step_images/#{step_image.id}", params: {
      step_image: {
        image: uploaded_image
      }
    }, headers: auth_headers_for(user)

    assert_response :success
    assert_match %r{\A/rails/active_storage/}, response_json.dig("step_image", "url")
  end

  test "deletes a step image" do
    user = create_user(username: "step_image_delete_owner", email: "step.image.delete.owner@example.com")
    step = build_step(user: user, title: "Tea")
    step_image = attach_test_image(StepImage.new(step: step))

    delete "/api/step_images/#{step_image.id}", headers: auth_headers_for(user)

    assert_response :success
    assert_equal "Step image deleted", response_json["message"]
    assert_not StepImage.exists?(step_image.id)
  end

  test "returns validation errors when step id is not editable" do
    user = create_user(username: "step_image_intruder", email: "step.image.intruder@example.com")
    owner = create_user(username: "step_image_owner_x", email: "step.image.owner.x@example.com")
    step = build_step(user: owner, title: "Locked")

    post "/api/step_images", params: {
      step_image: {
        step_id: step.id,
        image: uploaded_image
      }
    }, headers: auth_headers_for(user)

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "step_id")
  end
end
