# frozen_string_literal: true

class BookBorrowSerializer
  include JSONAPI::Serializer

  attributes :id, :book_id, :returned, :user_id

  attribute :start_date do |record|
    record.start_date&.strftime('%d/%m/%Y')
  end

  attribute :due_date do |record|
    record.due_date&.strftime('%d/%m/%Y')
  end
end
