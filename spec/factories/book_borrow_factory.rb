# frozen_string_literal: true

FactoryBot.define do
  factory :book_borrow do
    book
    user
    due_date { 2.weeks.from_now }
    start_date { Time.zone.today }
    returned { false }
  end
end
