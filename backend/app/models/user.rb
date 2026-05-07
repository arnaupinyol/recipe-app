class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :allergies, class_name: "Allergy"

  has_many :blocks_as_blocker, class_name: "Block", foreign_key: :blocker_id, dependent: :destroy,
                               inverse_of: :blocker
  has_many :blocked_users, through: :blocks_as_blocker, source: :blocked
  has_many :blocks_as_blocked, class_name: "Block", foreign_key: :blocked_id, dependent: :destroy,
                               inverse_of: :blocked
  has_many :blockers, through: :blocks_as_blocked, source: :blocker
  has_many :comments, dependent: :destroy, inverse_of: :user
  has_many :shopping_lists, dependent: :destroy, inverse_of: :user
  has_many :recipes, dependent: :destroy, inverse_of: :user
  has_many :follows_as_follower, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy,
                                 inverse_of: :follower
  has_many :followed_users, through: :follows_as_follower, source: :followed
  has_many :follows_as_followed, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy,
                                 inverse_of: :followed
  has_many :followers, through: :follows_as_followed, source: :follower
  has_many :user_saved_recipes, dependent: :destroy, inverse_of: :user
  has_many :saved_recipes, through: :user_saved_recipes, source: :recipe
  has_many :user_recipe_likes, dependent: :destroy, inverse_of: :user
  has_many :liked_recipes, through: :user_recipe_likes, source: :recipe

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
