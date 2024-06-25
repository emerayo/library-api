# frozen_string_literal: true

require 'rails_helper'

describe 'API Books' do
  include ApiHelper

  let(:user) { create(:user) }
  let(:json_response) { response.parsed_body }
  let(:headers) { auth_headers(user) }

  describe 'POST /create' do
    subject { post books_url, params: params.to_json, headers: headers }

    let(:valid_params) do
      {
        book: {
          author: Faker::Book.author,
          title: Faker::Book.title,
          genre: Faker::Book.genre,
          isbn: Faker::Code.isbn,
          copies: 10
        }
      }
    end

    let(:invalid_params) do
      {
        book: {
          author: Faker::Book.author,
          title: Faker::Book.title,
          genre: Faker::Book.genre,
          copies: 10
        }
      }
    end

    context 'when user is member' do
      context 'with valid params' do
        let(:params) { valid_params }

        it 'does not create a new Book and returns unauthorized' do
          expect { subject }.not_to(change { Book.count })
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with missing params' do
        let(:params) { invalid_params }

        it 'returns status code unauthorized' do
          expect { subject }.not_to(change { Book.count })
          expect(response.status).to eq 401
        end
      end
    end

    context 'when user is librarian' do
      let(:user) { create(:user, :librarian) }

      context 'with valid params' do
        let(:params) { valid_params }

        it 'creates a new Book and returns status code success 201' do
          expect { subject }.to change { Book.count }.by(1)
          expect(response).to have_http_status(:created)

          expect(json_response['id']).to_not be_nil
          expect(json_response['author']).to eq params[:book][:author]
          expect(json_response['title']).to eq params[:book][:title]
          expect(json_response['genre']).to eq params[:book][:genre]
          expect(json_response['isbn']).to eq params[:book][:isbn]
          expect(json_response['copies']).to eq params[:book][:copies]
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
    let!(:book) { create(:book) }

    subject { put book_path(book), params: params.to_json, headers: headers }

    let(:valid_params) do
      {
        book: {
          author: 'Agatha Christie'
        }
      }
    end

    let(:invalid_params) do
      {
        book: {
          title: ''
        }
      }
    end

    context 'when user is a member' do
      context 'with valid parameters' do
        let(:params) { valid_params }

        it 'does not update the book and returns unauthorized 401' do
          subject

          book.reload

          expect(book.author).not_to eq params[:book][:author]
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

      context 'when the Book does not exist' do
        it 'returns status code unauthorized 401' do
          patch book_path(1)

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when user is a librarian' do
      let(:user) { create(:user, :librarian) }

      context 'with valid parameters' do
        let(:params) { valid_params }

        it 'updates the requested book and returns ok 200' do
          subject

          book.reload

          expect(book.author).to eq params[:book][:author]
          expect(response).to have_http_status(:ok)

          expect(json_response['id']).to eq book.id
          expect(json_response['author']).to eq book.author
          expect(json_response['title']).to eq book.title
          expect(json_response['genre']).to eq book.genre
          expect(json_response['isbn']).to eq book.isbn
          expect(json_response['copies']).to eq book.copies
        end
      end

      context 'with invalid parameters' do
        let(:params) { invalid_params }

        it 'returns status code unprocessable_entity 422' do
          subject

          expect(response.status).to eq 422
        end
      end

      context 'when the Book does not exist' do
        let(:book) { 0 }
        let(:params) { invalid_params }

        it 'returns status code not found 404' do
          subject

          expect(response).to have_http_status(:not_found)
          expect(json_response).to eq({ 'error' => 'not-found' })
        end
      end
    end
  end

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

  describe 'GET /search' do
    subject { get search_books_path, params: { by_title: 'mermaid' }, headers: headers }

    context 'when there is no Book that matches search' do
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
      let!(:book) { create(:book, title: 'Little Mermaid') }

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

  describe 'DELETE /destroy' do
    context 'when user is member' do
      context 'when book exists' do
        let!(:book) { create(:book) }

        subject { delete book_path(book), headers: headers }

        it 'does not delete and returns status code unauthorized 401' do
          subject

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when book not found' do
        subject { delete book_path(0), headers: headers }

        it 'returns status code unauthorized 401' do
          subject

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when user is librarian' do
      let(:user) { create(:user, :librarian) }

      context 'when book exists' do
        let!(:book) { create(:book) }

        subject { delete book_path(book), headers: headers }

        it 'returns status code no content 204' do
          subject

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when book not found' do
        subject { delete book_path(0), headers: headers }

        it 'returns status code not found 404' do
          subject

          expect(response).to have_http_status(:not_found)
          expect(json_response).to eq({ 'error' => 'not-found' })
        end
      end
    end
  end
end
