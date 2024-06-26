# frozen_string_literal: true

class BookBorrowSerializer
  include JSONAPI::Serializer

  attributes :id, :due_date, :book_id, :returned, :start_date, :user_id
end
