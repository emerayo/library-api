# frozen_string_literal: true

FactoryBot.define do
  factory :book_borrow do
    book
    user
    due_date { Time.zone.today + 2.weeks }
    start_date { Time.zone.today }
    returned { false }
  end
end
