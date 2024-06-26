# frozen_string_literal: true

require 'rails_helper'

describe 'API BookBorrows' do
  include ApiHelper

  let(:user) { create(:user) }
  let(:book) { create(:book, copies: 10) }

  let(:json_response) { response.parsed_body }
  let(:headers) { auth_headers(user) }

  describe 'POST /create' do
    subject { post book_borrows_path, params: params.to_json, headers: headers }

    let(:valid_params) do
      {
        book_borrow: {
          user_id: user.id,
          book_id: book.id,
          due_date: '25-06-2024',
          start_date: '11-06-2024'
        }
      }
    end

    let(:invalid_params) do
      {
        book_borrow: {
          user_id: user.id,
          due_date: '25-06-2024',
          start_date: '11-06-2024'
        }
      }
    end

    context 'when user is member' do
      context 'with valid params' do
        let(:params) { valid_params }

        it 'creates a new BookBorrow and returns created 201' do
          expect { subject }.to(change { BookBorrow.count }.from(0).to(1))
          expect(response).to have_http_status(:created)
        end
      end

      context 'with missing params' do
        let(:params) { invalid_params }

        it 'returns status code unprocessable entity 422' do
          expect { subject }.not_to(change { BookBorrow.count })
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is librarian' do
      let(:user) { create(:user, :librarian) }

      context 'with valid params' do
        let(:params) { valid_params }

        it 'creates a new BookBorrow and returns status code success 201' do
          expect { subject }.to change { BookBorrow.count }.by(1)
          expect(response).to have_http_status(:created)

          expect(json_response['id']).to_not be_nil
          expect(json_response['due_date']).to eq '25/06/2024'
          expect(json_response['start_date']).to eq '11/06/2024'
          expect(json_response['book_id']).to eq params[:book_borrow][:book_id]
          expect(json_response['user_id']).to eq params[:book_borrow][:user_id]
        end
      end

      context 'with missing params' do
        let(:params) { invalid_params }

        it 'returns status code unprocessable_entity 422' do
          expect { subject }.not_to(change { Book.count })
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /update' do
    let(:member) { create(:user) }
    let!(:book_borrow) { create(:book_borrow, user: member) }

    subject { put book_borrow_path(book_borrow), params: params.to_json, headers: headers }

    let(:valid_params) do
      {
        book_borrow: {
          returned: true
        }
      }
    end

    let(:invalid_params) do
      {
        book_borrow: {
          returned: ''
        }
      }
    end

    context 'when user is a member' do
      context 'with valid parameters' do
        let(:params) { valid_params }

        it 'does not update the BookBorrow and returns unauthorized 401' do
          subject

          book_borrow.reload

          expect(book_borrow.returned).to eq false
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with invalid parameters' do
        let(:params) { invalid_params }

        it 'returns status code unauthorized 401' do
          subject

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when the BookBorrow does not exist' do
        it 'returns status code unauthorized 401' do
          patch book_borrow_path(1)

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when user is a librarian' do
      let(:user) { create(:user, :librarian) }

      context 'with valid parameters' do
        let(:params) { valid_params }

        it 'updates the requested BookBorrow and returns ok 200' do
          subject

          book_borrow.reload

          expect(book_borrow.returned).to eq true
          expect(response).to have_http_status(:ok)

          expect(json_response['id']).to eq book_borrow.id
          expect(json_response['book_id']).to eq book_borrow.book_id
          expect(json_response['user_id']).to eq book_borrow.user_id
          expect(json_response['returned']).to eq true
        end
      end

      context 'with invalid parameters' do
        let(:params) { invalid_params }

        it 'returns status code unprocessable_entity 422' do
          subject

          expect(response.status).to eq 422
        end
      end

      context 'when the BookBorrow does not exist' do
        let(:book_borrow) { 0 }
        let(:params) { invalid_params }

        it 'returns status code not found 404' do
          subject

          expect(response).to have_http_status(:not_found)
          expect(json_response).to eq({ 'error' => 'not-found' })
        end
      end
    end
  end
end
