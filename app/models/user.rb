# frozen_string_literal: true

class User < ApplicationRecord
  has_many :book_borrows, dependent: :destroy

  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: {
    'member' => 'member',
    'librarian' => 'librarian'
  }

  validates :role, presence: true
end
