# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname,
            uniqueness: { case_sensitive: false },
            presence: true

  validates :email,
            uniqueness: { case_sensitive: false },
            presence: true

  validates :first_name,
            presence: true

  validates :last_name,
            presence: true

  validates :birthday,
            presence: true

  validates :password,
            presence: true

  has_one_attached :avatar
end
