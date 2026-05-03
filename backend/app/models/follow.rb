class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", inverse_of: :follows_as_follower
  belongs_to :followed, class_name: "User", inverse_of: :follows_as_followed

  validates :followed_at, presence: true
  validates :followed_id, uniqueness: { scope: :follower_id }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    return unless follower_id.present? && follower_id == followed_id

    errors.add(:followed_id, "cannot be the same user as the follower")
  end
end
