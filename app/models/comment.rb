# frozen_string_literal: true

class Comment < ApplicationRecord
  validates_presence_of :content

  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :user

  has_many :likes, as: :likeable, dependent: :destroy
end
