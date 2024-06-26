# frozen_string_literal: true

require 'rails_helper'

describe Book, type: :model do
  subject { build(:book) }

  describe 'associations' do
    it { should have_many(:book_borrows).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:copies) }
    it { is_expected.to validate_presence_of(:genre) }
    it { is_expected.to validate_presence_of(:isbn) }
    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_numericality_of(:copies) }
  end

  describe 'scopes' do
    context '#by_title' do
      let!(:other_book) { create(:book, title: 'Little Writer') }

      subject { described_class.by_title('mermaid') }

      context 'when there is no match' do
        it 'returns a blank relation' do
          expect(subject).to eq []
        end
      end

      context 'when there is a match' do
        let!(:match_book) { create(:book, title: 'Little Mermaid') }

        it 'returns a relation with the match' do
          expect(subject).to eq [match_book]
        end
      end
    end

    context '#by_author' do
      let!(:other_book) { create(:book, author: 'Little Writer') }

      subject { described_class.by_author('agatha') }

      context 'when there is no match' do
        it 'returns a blank relation' do
          expect(subject).to eq []
        end
      end

      context 'when there is a match' do
        let!(:match_book) { create(:book, author: 'Agatha Christie') }

        it 'returns a relation with the match' do
          expect(subject).to eq [match_book]
        end
      end
    end

    context '#by_genre' do
      let!(:other_book) { create(:book, genre: 'Adventure') }

      subject { described_class.by_genre('drama') }

      context 'when there is no match' do
        it 'returns a blank relation' do
          expect(subject).to eq []
        end
      end

      context 'when there is a match' do
        let!(:match_book) { create(:book, genre: 'Drama') }

        it 'returns a relation with the match' do
          expect(subject).to eq [match_book]
        end
      end
    end
  end

  describe '#available?' do
    let(:book) { create(:book, copies: 1) }

    subject { book.available? }

    context 'when there is no book borrow' do
      it 'returns original copies number' do
        expect(subject).to eq true
      end
    end

    context 'when there is at least one book borrow' do
      context 'when the book was already returned' do
        let!(:book_borrow) { create(:book_borrow, book: book, returned: true) }

        it 'returns original copies number' do
          expect(subject).to eq true
        end
      end

      context 'when the book was not returned' do
        let!(:book_borrow) { create(:book_borrow, book: book, returned: false) }

        it 'returns original copies less the amount of book borrow not returned' do
          expect(subject).to eq false
        end
      end
    end
  end

  describe '#available_copies' do
    let(:book) { create(:book, copies: 10) }

    subject { book.available_copies }

    context 'when there is no book borrow' do
      it 'returns original copies number' do
        expect(subject).to eq 10
      end
    end

    context 'when there is at least one book borrow' do
      context 'when the book was already returned' do
        let!(:book_borrow) { create(:book_borrow, book: book, returned: true) }

        it 'returns original copies number' do
          expect(subject).to eq 10
        end
      end

      context 'when the book was not returned' do
        let!(:book_borrow) { create(:book_borrow, book: book, returned: false) }

        it 'returns original copies less the amount of book borrow not returned' do
          expect(subject).to eq 9
        end
      end
    end
  end

  describe '#unreturned_books' do
    let(:book) { create(:book, copies: 10) }

    subject { book.unreturned_books }

    context 'when there is no book borrow' do
      it 'returns a blank relation' do
        expect(subject).to eq []
      end
    end

    context 'when there is at least one book borrow' do
      context 'when the book was already returned' do
        let!(:book_borrow) { create(:book_borrow, book: book, returned: true) }

        it 'returns a blank relation' do
          expect(subject).to eq []
        end
      end

      context 'when the book was not returned' do
        let!(:book_borrow) { create(:book_borrow, book: book, returned: false) }

        it 'returns a relation with the book_borrow' do
          expect(subject).to eq [book_borrow]
        end
      end
    end
  end

  describe '#overdue_borrows' do
    let(:book) { create(:book, copies: 10) }

    subject { book.overdue_borrows }

    context 'when there is no book borrow' do
      it 'returns a blank relation' do
        expect(subject).to eq []
      end
    end

    context 'when there is at least one book borrow' do
      context "when the book's due_date is tomorrow" do
        let!(:book_borrow) do
          create(:book_borrow, book: book, returned: true,
                               start_date: 13.days.ago, due_date: 1.day.from_now)
        end

        it 'returns a blank relation' do
          expect(subject).to eq []
        end
      end

      context "when the book's due_date was yesterday" do
        let!(:book_borrow) do
          create(:book_borrow, book: book, returned: false,
                               start_date: 15.days.ago, due_date: 1.day.ago)
        end
        let!(:borrow_returned) do
          create(:book_borrow, book: book, returned: true,
                               start_date: 15.days.ago, due_date: 1.day.ago)
        end

        it 'returns a relation with the not returned book_borrow' do
          expect(subject).to eq [book_borrow]
        end
      end
    end
  end
end
