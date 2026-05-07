require "test_helper"

class StepImagesTest < ActionDispatch::IntegrationTest
  def create_step_for(title:)
    user = User.create!(
      username: "step_image_#{title.downcase}",
      email: "step.image.#{title.downcase}@example.com",
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

    Step.create!(recipe: recipe, description: "Prepare #{title}", order_number: 1)
  end

  test "lists step images" do
    step_1 = create_step_for(title: "Soup")
    step_2 = create_step_for(title: "Cake")

    StepImage.create!(step: step_1, url: "https://example.com/soup-step.jpg")
    StepImage.create!(step: step_2, url: "https://example.com/cake-step.jpg")

    get "/api/step_images"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 2, response_body["step_images"].length
  end

  test "shows a step image" do
    step = create_step_for(title: "Bread")
    step_image = StepImage.create!(step: step, url: "https://example.com/bread-step.jpg")

    get "/api/step_images/#{step_image.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Bread", response_body.dig("step_image", "recipe_title")
    assert_equal 1, response_body.dig("step_image", "step_order_number")
  end

  test "creates a step image" do
    step = create_step_for(title: "Pizza")

    post "/api/step_images", params: {
      step_image: {
        step_id: step.id,
        url: "https://example.com/pizza-step.jpg"
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal step.id, response_body.dig("step_image", "step_id")
  end

  test "updates a step image" do
    step = create_step_for(title: "Rice")
    step_image = StepImage.create!(step: step, url: "https://example.com/rice-old.jpg")

    patch "/api/step_images/#{step_image.id}", params: {
      step_image: {
        url: "https://example.com/rice-new.jpg"
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "https://example.com/rice-new.jpg", response_body.dig("step_image", "url")
  end

  test "deletes a step image" do
    step = create_step_for(title: "Tea")
    step_image = StepImage.create!(step: step, url: "https://example.com/tea-step.jpg")

    delete "/api/step_images/#{step_image.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Step image deleted", response_body["message"]
    assert_not StepImage.exists?(step_image.id)
  end

  test "returns not found for a missing step image" do
    get "/api/step_images/999999"

    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Step image not found", response_body.dig("error", "message")
  end

  test "returns validation errors when step image is invalid" do
    step = create_step_for(title: "Pasta")

    post "/api/step_images", params: {
      step_image: {
        step_id: step.id,
        url: ""
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Step image creation failed", response_body.dig("error", "message")
    assert response_body.dig("error", "details", "url").present?
  end

  test "returns validation errors when step id is invalid" do
    post "/api/step_images", params: {
      step_image: {
        step_id: 999999,
        url: "https://example.com/missing-step.jpg"
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal "Step image creation failed", response_body.dig("error", "message")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "step_id")
  end
end
