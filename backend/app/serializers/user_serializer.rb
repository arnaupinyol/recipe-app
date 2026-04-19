class UserSerializer
  def self.render(user)
    {
      id: user.id,
      username: user.username,
      email: user.email,
      bio: user.bio,
      profile_image_url: user.profile_image_url,
      language: user.language,
      private_profile: user.private_profile,
      notifications_enabled: user.notifications_enabled,
      account_status: user.account_status,
      role: user.role,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
