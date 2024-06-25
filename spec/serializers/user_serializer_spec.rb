# frozen_string_literal: true

require 'rails_helper'

describe UserSerializer, type: :model do
  let(:user) { create(:user) }

  subject { UserSerializer.new(user).serializable_hash[:data][:attributes] }

  describe 'attributes' do
    it 'displays the attributes correctly' do
      expect(subject[:id]).to eq user.id
      expect(subject[:email]).to eq user.email
      expect(subject[:role]).to eq user.role
      expect(subject[:created_at]).to eq user.created_at
    end
  end
end
