class User < ApplicationRecord
  has_secure_password

  enum :account_status, { active: 0, suspended: 1, deleted: 2 }
  enum :role, { user: 0, moderator: 1, admin: 2 }

  before_validation :normalize_email
  before_validation :normalize_username

  validates :username, presence: true, length: { minimum: 3, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/ },
                       uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :language, presence: true

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def normalize_username
    self.username = username.to_s.strip.downcase
  end
end
