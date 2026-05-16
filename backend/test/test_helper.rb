ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "rack/test"
require "stringio"

module ApiTestHelpers
  def create_user(username:, email:, role: :user, account_status: :active, **attributes)
    User.create!(
      {
        username: username,
        email: email,
        password: "password123",
        password_confirmation: "password123",
        role: role,
        account_status: account_status
      }.merge(attributes)
    )
  end

  def create_recipe_for(user:, title:, visibility: :public_recipe, **attributes)
    Recipe.create!(
      {
        user: user,
        title: title,
        description: "Recipe description",
        preparation_time_minutes: 20,
        difficulty: 2,
        servings: 2,
        visibility: visibility
      }.merge(attributes)
    )
  end

  def auth_headers_for(user)
    {
      "Authorization" => "Bearer #{JsonWebToken.encode(user_id: user.id)}"
    }
  end

  def response_json
    JSON.parse(response.body)
  end

  def uploaded_image(filename: "test-image.png", content_type: "image/png")
    Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/#{filename}"), content_type)
  end

  def attach_test_image(record, attachment_name: :image, filename: "test-image.png", content_type: "image/png")
    record.public_send(attachment_name).attach(
      io: StringIO.new("test image"),
      filename: filename,
      content_type: content_type
    )
    record.save!
    record
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include ApiTestHelpers
  end
end

class ActionDispatch::IntegrationTest
  include ApiTestHelpers
end
