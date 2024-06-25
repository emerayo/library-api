# frozen_string_literal: true

require 'rails_helper'

describe 'API Books' do
  include ApiHelper

  let(:json_response) { response.parsed_body }
  let(:headers) { auth_headers(user) }

  let(:user) { create(:user) }

  describe 'GET /index' do
    subject { get books_url, headers: headers }

    context 'when there is no Book' do
      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns a blank array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response).to eq([])
      end
    end

    context 'when there is at least one Book' do
      let!(:book) { create(:book) }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns an array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.size).to eq 1

        expect(json_response.first['id']).to eq book.id
        expect(json_response.first['author']).to eq book.author
        expect(json_response.first['title']).to eq book.title
        expect(json_response.first['genre']).to eq book.genre
        expect(json_response.first['isbn']).to eq book.isbn
        expect(json_response.first['copies']).to eq book.copies
      end
    end
  end
end
