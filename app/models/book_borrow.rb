# frozen_string_literal: true

class BookBorrow < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :due_date, :start_date, presence: true
  validates :due_date, comparison: { equal_to: :valid_due_date }, if: :start_date?
  validates :returned, inclusion: [true, false]

  validates :book_id, uniqueness: { scope: :user_id }

  validate :available_book, if: :book_id?

  scope :overdue, -> { where(due_date: ...Time.zone.today, returned: false) }

  private

  def valid_due_date
    start_date + 2.weeks
  end

  def available_book
    return if book.available?

    errors.add(:book_id, 'No available copies at the moment')
  end
end
