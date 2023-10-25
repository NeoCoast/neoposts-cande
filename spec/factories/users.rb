# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    # nickname with no "."
    nickname { Faker::Internet.username.tr('.', '_') }
    last_name { Faker::Name.last_name }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    password { Faker::Internet.password }

    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')

    after(:build) do |user|
      user.avatar.attach(
        io: File.open(image_path),
        filename: 'default.webp',
        content_type: 'image/webp'
      )
    end
  end
end
