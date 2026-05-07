class BlockSerializer
  def self.render(block)
    {
      id: block.id,
      blocker_id: block.blocker_id,
      blocker_username: block.blocker.username,
      blocked_id: block.blocked_id,
      blocked_username: block.blocked.username,
      blocked_at: block.blocked_at
    }
  end
end
