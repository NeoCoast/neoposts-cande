# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :rememberable

  validates :nickname,
            uniqueness: { case_sensitive: false }

  before_save :capitalize_attributes

  validates :email,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[^@\s]+@[^@\s]+\.[a-z]+\z/i, message: 'Email needs to include a "@" and ".com"' },
            if: -> { email.present? }

  validates :nickname, format: { without: /\./, message: 'should not include a period (".")' }

  validates :birthday, comparison: { less_than: Date.current, message: 'birthday cannot be in the future' },
                       if: -> { birthday.present? }

  validate :avatar_file_type, if: -> { avatar.present? }

  validates_presence_of :nickname, :email, :first_name, :last_name, :birthday, :avatar

  has_one_attached :avatar

  has_many :posts

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :followers, through: :passive_relationships

  has_many :followed_posts, through: :following, source: :posts

  def follow(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  has_many :comments

  has_many :likes

  def self.filter_users(filter)
    User.where('LOWER(nickname) LIKE ?',
               "%#{filter}%").or(User.where("LOWER(CONCAT(first_name, ' ', last_name)) LIKE ?", "%#{filter}%"))
  end

  private

  def capitalize_attributes
    self.first_name = first_name.capitalize if first_name.present?
    self.last_name = last_name.capitalize if last_name.present?
  end

  def avatar_file_type
    return unless avatar.attached?

    return if ['image/jpeg', 'image/png', 'image/gif', 'image/webp'].include?(avatar.content_type)

    avatar.purge
    errors.add(:avatar, 'wrong type of file')
  end
end
