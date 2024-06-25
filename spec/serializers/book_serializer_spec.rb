# frozen_string_literal: true

require 'rails_helper'

describe BookSerializer, type: :model do
  let(:book) { create(:book) }

  subject { BookSerializer.new(book).serializable_hash[:data][:attributes] }

  describe 'attributes' do
    it 'displays the attributes correctly' do
      expect(subject[:id]).to eq book.id
      expect(subject[:author]).to eq book.author
      expect(subject[:genre]).to eq book.genre
      expect(subject[:isbn]).to eq book.isbn
      expect(subject[:title]).to eq book.title
      expect(subject[:copies]).to eq book.copies
    end
  end
end
