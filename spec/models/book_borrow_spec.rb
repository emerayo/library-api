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
    it { is_expected.to validate_inclusion_of(:returned).in_array([true, false]) }
  end
end
