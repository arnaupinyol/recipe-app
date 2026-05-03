require "test_helper"

module Api
  class StatusControllerTest < ActionDispatch::IntegrationTest
    test "returns api status" do
      get "/api/status"

      assert_response :success

      response_body = JSON.parse(response.body)
      assert_equal "ok", response_body["status"]
      assert_equal "recipe_app", response_body["app"]
      assert_equal "ready", response_body["api"]
    end
  end
end
