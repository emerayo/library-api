# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 'member' }

    trait :librarian do
      role { 'librarian' }
    end
  end
end
