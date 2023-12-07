# frozen_string_literal: true

json.array! @users do |user|
  json.extract! user, :id, :email, :nickname, :first_name, :last_name, :birthday
end
