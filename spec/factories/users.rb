# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(domain: 'email.com') }
    first_name { Faker::Name.first_name.capitalize }
    nickname { Faker::Internet.username.tr('.', '_') }
    last_name { Faker::Name.last_name.capitalize }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    password { Faker::Internet.password }

    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')

    after(:build) do |user|
      user.avatar.attach(
        io: File.open(image_path),
        filename: 'download.jpeg',
        content_type: 'image/jpeg'
      )
    end
  end
end
