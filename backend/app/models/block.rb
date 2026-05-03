class Block < ApplicationRecord
  belongs_to :blocker, class_name: "User", inverse_of: :blocks_as_blocker
  belongs_to :blocked, class_name: "User", inverse_of: :blocks_as_blocked

  validates :blocked_at, presence: true
  validates :blocked_id, uniqueness: { scope: :blocker_id }
  validate :cannot_block_self

  private

  def cannot_block_self
    return unless blocker_id.present? && blocker_id == blocked_id

    errors.add(:blocked_id, "cannot be the same user as the blocker")
  end
end
