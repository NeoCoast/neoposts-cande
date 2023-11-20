# frozen_string_literal: true

class Post < ApplicationRecord
  validates_presence_of :title, :body

  validate :image_file_type

  before_create :set_published_at

  belongs_to :user

  has_one_attached :image

  scope :ordered_posts, -> { order(published_at: :desc) }

  has_many :comments, as: :commentable

  has_many :likes, as: :likeable

  def liked_by_current_user?(current_user)
    likes.exists?(user: current_user)
  end

  private

  def set_published_at
    self.published_at = Time.now
  end

  def image_file_type
    return unless image.attached? && !image.content_type.in?(%w[image/png image/jpg image/jpeg])

    image.purge  # Delete the invalid image
    errors.add(:image, 'must be a .jpg, .jpeg or .png image')
  end
end
