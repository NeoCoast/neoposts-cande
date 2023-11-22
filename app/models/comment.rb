# frozen_string_literal: true

class Comment < ApplicationRecord
  validates_presence_of :content

  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable

  belongs_to :user

  has_many :likes, as: :likeable
end
