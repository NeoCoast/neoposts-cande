# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :rememberable

  validates :nickname,
            uniqueness: { case_sensitive: false }

  validates :email,
            uniqueness: { case_sensitive: false }

  validates_presence_of :nickname, :email, :first_name, :last_name, :birthday, :avatar

  has_one_attached :avatar

  has_many :posts
end
