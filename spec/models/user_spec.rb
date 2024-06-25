# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }
  end

  describe 'enum' do
    it do
      should define_enum_for(:role)
        .with_values(
          'member' => 'member',
          'librarian' => 'librarian'
        ).backed_by_column_of_type(:string)
    end
  end
end
