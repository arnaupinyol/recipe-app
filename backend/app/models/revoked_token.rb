class RevokedToken < ApplicationRecord
  validates :jti, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active, -> { where("expires_at > ?", Time.current) }

  def self.revoked?(jti)
    return false if jti.blank?

    active.exists?(jti: jti)
  end
end
