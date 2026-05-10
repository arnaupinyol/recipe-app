require "test_helper"

class BlocksTest < ActionDispatch::IntegrationTest
  test "lists only the current user's blocks" do
    blocker = create_user(username: "block_owner_1", email: "block.owner.1@example.com")
    other_blocker = create_user(username: "block_owner_2", email: "block.owner.2@example.com")
    blocked = create_user(username: "block_target_1", email: "block.target.1@example.com")
    other_blocked = create_user(username: "block_target_2", email: "block.target.2@example.com")

    Block.create!(blocker: blocker, blocked: blocked)
    Block.create!(blocker: other_blocker, blocked: other_blocked)

    get "/api/blocks", headers: auth_headers_for(blocker)

    assert_response :success
    assert_equal 1, response_json["blocks"].length
    assert_equal blocked.id, response_json.dig("blocks", 0, "blocked_id")
  end

  test "shows an owned block" do
    blocker = create_user(username: "block_show_1", email: "block.show.1@example.com")
    blocked = create_user(username: "block_show_2", email: "block.show.2@example.com")
    block = Block.create!(blocker: blocker, blocked: blocked)

    get "/api/blocks/#{block.id}", headers: auth_headers_for(blocker)

    assert_response :success
    assert_equal blocker.username, response_json.dig("block", "blocker_username")
    assert_equal blocked.username, response_json.dig("block", "blocked_username")
  end

  test "creates a block for the authenticated user" do
    blocker = create_user(username: "block_create_1", email: "block.create.1@example.com")
    blocked = create_user(username: "block_create_2", email: "block.create.2@example.com")

    post "/api/blocks", params: {
      block: {
        blocker_id: 999999,
        blocked_id: blocked.id
      }
    }, headers: auth_headers_for(blocker), as: :json

    assert_response :created
    assert_equal blocker.id, response_json.dig("block", "blocker_id")
    assert_equal blocked.id, response_json.dig("block", "blocked_id")
  end

  test "updates an owned block" do
    blocker = create_user(username: "block_update_1", email: "block.update.1@example.com")
    blocked_1 = create_user(username: "block_update_2", email: "block.update.2@example.com")
    blocked_2 = create_user(username: "block_update_3", email: "block.update.3@example.com")
    block = Block.create!(blocker: blocker, blocked: blocked_1)

    patch "/api/blocks/#{block.id}", params: {
      block: {
        blocked_id: blocked_2.id
      }
    }, headers: auth_headers_for(blocker), as: :json

    assert_response :success
    assert_equal blocked_2.id, response_json.dig("block", "blocked_id")
  end

  test "deletes a block" do
    blocker = create_user(username: "block_delete_1", email: "block.delete.1@example.com")
    blocked = create_user(username: "block_delete_2", email: "block.delete.2@example.com")
    block = Block.create!(blocker: blocker, blocked: blocked)

    delete "/api/blocks/#{block.id}", headers: auth_headers_for(blocker)

    assert_response :success
    assert_equal "Block deleted", response_json["message"]
    assert_not Block.exists?(block.id)
  end

  test "returns validation errors when blocked user is invalid" do
    blocker = create_user(username: "block_invalid_rel", email: "block.invalid.rel@example.com")

    post "/api/blocks", params: {
      block: {
        blocked_id: 999998
      }
    }, headers: auth_headers_for(blocker), as: :json

    assert_response :unprocessable_entity
    assert_equal [ "contains an invalid value" ], response_json.dig("error", "details", "blocked_id")
  end

  test "returns validation errors when blocking self" do
    user = create_user(username: "block_self", email: "block.self@example.com")

    post "/api/blocks", params: {
      block: {
        blocked_id: user.id
      }
    }, headers: auth_headers_for(user), as: :json

    assert_response :unprocessable_entity
    assert response_json.dig("error", "details", "blocked_id").present?
  end
end
