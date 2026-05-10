class UserSerializer
  def self.render(user, viewer: nil)
    payload = {
      id: user.id,
      username: user.username,
      bio: user.bio,
      profile_image_url: user.profile_image_url,
      private_profile: user.private_profile,
      created_at: user.created_at,
      updated_at: user.updated_at
    }

    return payload unless private_view?(user, viewer)

    payload.merge(
      email: user.email,
      language: user.language,
      notifications_enabled: user.notifications_enabled,
      account_status: user.account_status,
      role: user.role,
      allergy_ids: user.allergies.order(:name).pluck(:id),
      allergies: user.allergies.order(:name).map do |allergy|
        {
          id: allergy.id,
          name: allergy.name
        }
      end
    )
  end

  def self.private_view?(user, viewer)
    viewer.present? && (viewer.id == user.id || viewer.admin?)
  end
end
