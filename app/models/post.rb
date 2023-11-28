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

  def self.define_posts(posts, params)
    posts = filter_posts(params, posts)
    sort_posts(params[:sort_by], posts)
  end

  def self.filter_posts(params, posts)
    posts = filter_author(posts, params[:author_filter])
    posts = filter_title(posts, params[:title_filter])
    posts = filter_body(posts, params[:body_filter])
    filter_date(posts, params[:date_filter])
  end

  def self.filter_author(posts, author)
    return posts if author.blank?

    user = User.where('LOWER(nickname) = ?', author.downcase).first
    posts = posts.where(user_id: user.id) if user.present?
    posts = posts.none if user.blank?
    posts
  end

  def self.filter_title(posts, title_filter)
    return posts if title_filter.blank?

    posts.where(title: title_filter)
  end

  def self.filter_body(posts, body_filter)
    return posts if body_filter.blank?

    posts.where(body: body_filter)
  end

  # :reek:ControlParameter
  def self.filter_date(posts, date_filter)
    now = Time.zone.now
    case date_filter
    when 'Last day'
      posts = posts.where('published_at >= ? ', now - 1.day)
    when 'Last week'
      posts = posts.where('published_at >= ?', now.beginning_of_week)
    when 'Last month'
      posts = posts.where('published_at >= ?', now.beginning_of_month)
    end
    posts
  end

  # :reek:ControlParameter
  def self.sort_posts(sort_by, posts)
    case sort_by
    when 'Trending'
      posts.by_trending
    when 'Number of likes'
      posts.by_likes
    else
      posts.by_publishing_date
    end
  end

  private

  def set_published_at
    self.published_at = Time.now
  end

  def image_file_type
    return unless image.attached? && !image.content_type.in?(%w[image/png image/jpg image/jpeg])

    image.purge # Delete the invalid image
    errors.add(:image, 'must be a .jpg, .jpeg or .png image')
  end
end
