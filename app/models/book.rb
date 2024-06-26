# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :book_borrows, dependent: :destroy

  validates :author, :copies, :genre, :isbn, :title, presence: true
  validates :copies, numericality: true

  scope :by_author, ->(string) { where('author ILIKE ?', "%#{string}%") }
  scope :by_title, ->(string) { where('title ILIKE ?', "%#{string}%") }
  scope :by_genre, ->(string) { where('genre ILIKE ?', "%#{string}%") }

  def available_copies
    copies - unreturned_books.count
  end

  def unreturned_books
    book_borrows.where(returned: false)
  end

  def overdue_borrows
    book_borrows.where(due_date: ...Time.zone.today, returned: false)
  end
end
