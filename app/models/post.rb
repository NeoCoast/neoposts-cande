# frozen_string_literal: true

class Post < ApplicationRecord
  validates_presence_of :title, :body

  validate :image_file_type

  before_create :set_published_at

  belongs_to :user

  has_one_attached :image

  scope :by_publishing_date, -> { order(published_at: :desc) }
  scope :by_likes, -> { order(likes_count: :desc) }
  scope :by_trending, lambda {
    select(
      'posts.*, ' \
      '(likes_count / ' \
      '(EXP(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - published_at)) / (24 * 60 * 60)) / 4)) AS trending'
    ).order('trending DESC')
  }

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy

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
