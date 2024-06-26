# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    isbn { Faker::Code.isbn }
    title { Faker::Book.title }
    copies { rand(1..20) }
  end
end
