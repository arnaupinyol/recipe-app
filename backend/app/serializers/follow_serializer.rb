class FollowSerializer
  def self.render(follow)
    {
      id: follow.id,
      follower_id: follow.follower_id,
      follower_username: follow.follower.username,
      followed_id: follow.followed_id,
      followed_username: follow.followed.username,
      followed_at: follow.followed_at
    }
  end
end
