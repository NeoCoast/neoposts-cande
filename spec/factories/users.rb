# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }

    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
