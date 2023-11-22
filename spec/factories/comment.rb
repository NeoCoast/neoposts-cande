# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence(word_count: 3) }
  end
end
