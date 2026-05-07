require "test_helper"

class BlocksTest < ActionDispatch::IntegrationTest
  def create_user(username:, email:)
    User.create!(
      username: username,
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "lists blocks" do
    blocker = create_user(username: "block_owner_1", email: "block.owner.1@example.com")
    blocked = create_user(username: "block_owner_2", email: "block.owner.2@example.com")

    Block.create!(blocker: blocker, blocked: blocked)

    get "/api/blocks"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal 1, response_body["blocks"].length
  end

  test "shows a block" do
    blocker = create_user(username: "block_show_1", email: "block.show.1@example.com")
    blocked = create_user(username: "block_show_2", email: "block.show.2@example.com")
    block = Block.create!(blocker: blocker, blocked: blocked)

    get "/api/blocks/#{block.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal blocker.username, response_body.dig("block", "blocker_username")
    assert_equal blocked.username, response_body.dig("block", "blocked_username")
  end

  test "creates a block" do
    blocker = create_user(username: "block_create_1", email: "block.create.1@example.com")
    blocked = create_user(username: "block_create_2", email: "block.create.2@example.com")

    post "/api/blocks", params: {
      block: {
        blocker_id: blocker.id,
        blocked_id: blocked.id
      }
    }, as: :json

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal blocker.id, response_body.dig("block", "blocker_id")
    assert_equal blocked.id, response_body.dig("block", "blocked_id")
  end

  test "updates a block" do
    blocker = create_user(username: "block_update_1", email: "block.update.1@example.com")
    blocked_1 = create_user(username: "block_update_2", email: "block.update.2@example.com")
    blocked_2 = create_user(username: "block_update_3", email: "block.update.3@example.com")
    block = Block.create!(blocker: blocker, blocked: blocked_1)

    patch "/api/blocks/#{block.id}", params: {
      block: {
        blocked_id: blocked_2.id
      }
    }, as: :json

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal blocked_2.id, response_body.dig("block", "blocked_id")
  end

  test "deletes a block" do
    blocker = create_user(username: "block_delete_1", email: "block.delete.1@example.com")
    blocked = create_user(username: "block_delete_2", email: "block.delete.2@example.com")
    block = Block.create!(blocker: blocker, blocked: blocked)

    delete "/api/blocks/#{block.id}"

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal "Block deleted", response_body["message"]
    assert_not Block.exists?(block.id)
  end

  test "returns validation errors when block relations are invalid" do
    post "/api/blocks", params: {
      block: {
        blocker_id: 999999,
        blocked_id: 999998
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "blocker_id")
    assert_equal [ "contains an invalid value" ], response_body.dig("error", "details", "blocked_id")
  end

  test "returns validation errors when blocking self" do
    user = create_user(username: "block_self", email: "block.self@example.com")

    post "/api/blocks", params: {
      block: {
        blocker_id: user.id,
        blocked_id: user.id
      }
    }, as: :json

    assert_response :unprocessable_entity

    response_body = JSON.parse(response.body)
    assert response_body.dig("error", "details", "blocked_id").present?
  end
end
