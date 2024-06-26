# frozen_string_literal: true

require 'rails_helper'

describe BookBorrowSerializer, type: :model do
  let(:book_borrow) { create(:book_borrow) }

  subject { BookBorrowSerializer.new(book_borrow).serializable_hash[:data][:attributes] }

  describe 'attributes' do
    it 'displays the attributes correctly' do
      expect(subject[:id]).to eq book_borrow.id
      expect(subject[:user_id]).to eq book_borrow.user_id
      expect(subject[:book_id]).to eq book_borrow.book_id
      expect(subject[:returned]).to eq book_borrow.returned
      expect(subject[:due_date]).to eq book_borrow.due_date.strftime('%d/%m/%Y')
      expect(subject[:start_date]).to eq book_borrow.start_date.strftime('%d/%m/%Y')
    end
  end
end
