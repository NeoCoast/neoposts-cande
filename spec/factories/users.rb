# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    nickname { Faker::Internet.username }
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    password { Faker::Internet.password }

    after(:build) do |user|
      user.avatar.attach(
        io: File.open(Rails.root.join('spec', 'default.webp')),
        filename: 'default.webp',
        content_type: 'image/webp'
      )
    end
  end
end
