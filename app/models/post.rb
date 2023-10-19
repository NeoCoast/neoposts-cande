# frozen_string_literal: true

class Post < ApplicationRecord
  validates_presence_of :title, :body
  before_create :set_published_at

  belongs_to :user

  has_one_attached :image

  private

  def set_published_at
    self.published_at = Time.now
  end
end
