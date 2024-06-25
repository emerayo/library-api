# frozen_string_literal: true

class BookSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :genre, :isbn, :author, :copies, :created_at
end
