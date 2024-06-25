# frozen_string_literal: true

class Book < ApplicationRecord
  validates :author, :copies, :genre, :isbn, :title, presence: true
  validates :copies, numericality: true

  scope :by_author, ->(string) { where('author ILIKE ?', "%#{string}%") }
  scope :by_title, ->(string) { where('title ILIKE ?', "%#{string}%") }
  scope :by_genre, ->(string) { where('genre ILIKE ?', "%#{string}%") }
end
