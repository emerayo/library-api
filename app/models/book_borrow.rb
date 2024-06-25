# frozen_string_literal: true

class BookBorrow < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :due_date, :start_date, presence: true
  validates :returned, inclusion: [true, false]
end
