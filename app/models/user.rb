# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :rememberable

  validates :nickname,
            uniqueness: { case_sensitive: false },
            presence: true

  validates :email,
            uniqueness: { case_sensitive: false }

  validates :first_name,
            presence: true

  validates :last_name,
            presence: true

  validates :birthday,
            presence: true

  validates :avatar,
            presence: true

  has_one_attached :avatar
end
