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
      allergy_ids: user.allergies.order(:name).pluck(:id),
      allergies: user.allergies.order(:name).map do |allergy|
        {
          id: allergy.id,
          name: allergy.name
        }
      end,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
