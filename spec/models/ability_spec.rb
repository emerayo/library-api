# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe 'User' do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }

    context 'when user is member' do
      let(:user) { create(:user) }

      it { is_expected.not_to be_able_to(:manage, Book) }
      it { is_expected.not_to be_able_to(:update, BookBorrow) }

      it { is_expected.to be_able_to(:read, Book) }
      it { is_expected.to be_able_to(:search, Book) }
      it { is_expected.to be_able_to(:create, BookBorrow) }
    end

    context 'when user is librarian' do
      let(:user) { create(:user, :librarian) }

      it { is_expected.to be_able_to(:manage, :all) }
    end
  end
end
