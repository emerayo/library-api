# frozen_string_literal: true

require 'rails_helper'

describe Book, type: :model do
  subject { build(:book) }

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
end
