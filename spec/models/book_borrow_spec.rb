# frozen_string_literal: true

require 'rails_helper'

describe BookBorrow, type: :model do
  subject { build(:book_borrow) }

  describe 'associations' do
    it { should belong_to(:book)  }
    it { should belong_to(:user)  }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_presence_of(:start_date) }
    it {
      is_expected.to validate_comparison_of(:due_date).is_equal_to(subject.start_date + 2.weeks)
    }

    it { is_expected.to validate_inclusion_of(:returned).in_array([true, false]) }

    it { is_expected.to validate_uniqueness_of(:book_id).scoped_to(:user_id) }

    context 'book availability' do
      context 'when there is no copy available' do
        let(:book) { create(:book, copies: 1) }
        let!(:book_borrow) { create(:book_borrow, book: book) }
        let(:new_record) { build(:book_borrow, book: book) }

        it { expect(new_record).to_not be_valid }
      end

      context 'when there is a copy available' do
        it { is_expected.to be_valid }
      end
    end
  end

  describe 'delegations' do
    it { should delegate_method(:email).to(:user).with_prefix }
  end

  describe 'scopes' do
    describe '#overdue' do
      let(:book) { create(:book, copies: 10) }

      subject { described_class.overdue }

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
end
