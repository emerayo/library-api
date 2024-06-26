# frozen_string_literal: true

require 'rails_helper'

describe 'API Dashboard' do
  include ApiHelper

  let(:user) { create(:user) }
  let(:book) { create(:book, copies: 10) }

  let(:json_response) { response.parsed_body }
  let(:headers) { auth_headers(user) }

  describe 'GET /index' do
    subject { get dashboard_path, headers: headers }

    context 'when user is member' do
      context 'when user has at least one BookBorrow but no overdue borrows' do
        let!(:book_borrow) { create(:book_borrow, book: book, user: user) }

        it 'returns a list with one BookBorrow but no overdue borrows' do
          subject

          expect(response).to have_http_status(:ok)

          first_borrow = json_response['book_borrows'].first

          expect(json_response['book_borrows']).to be_an_instance_of(Array)
          expect(json_response['book_borrows'].size).to eq 1
          expect(first_borrow['start_date']).to eq book_borrow.start_date.strftime('%d/%m/%Y')
          expect(first_borrow['due_date']).to eq book_borrow.due_date.strftime('%d/%m/%Y')
          expect(first_borrow['book']['author']).to eq book.author
          expect(first_borrow['book']['title']).to eq book.title
          expect(first_borrow['book']['isbn']).to eq book.isbn

          expect(json_response['overdue_borrows']).to eq([])
        end
      end

      context 'when user has at least one BookBorrow but no overdue borrows' do
        let!(:book_borrow) do
          create(:book_borrow, book: book, returned: false, user: user,
                               start_date: 15.days.ago, due_date: 1.day.ago)
        end

        it 'returns a list with one BookBorrow but no overdue borrows' do
          subject

          expect(response).to have_http_status(:ok)

          first_overdue = json_response['overdue_borrows'].first

          expect(json_response['overdue_borrows']).to be_an_instance_of(Array)
          expect(json_response['overdue_borrows'].size).to eq 1
          expect(first_overdue['start_date']).to eq book_borrow.start_date.strftime('%d/%m/%Y')
          expect(first_overdue['due_date']).to eq book_borrow.due_date.strftime('%d/%m/%Y')
          expect(first_overdue['book']['author']).to eq book.author
          expect(first_overdue['book']['title']).to eq book.title
          expect(first_overdue['book']['isbn']).to eq book.isbn
        end
      end
    end

    context 'when user is librarian' do
      let(:user) { create(:user, :librarian) }

      context 'when a member has at least one BookBorrow but no overdue borrows' do
        let!(:book_borrow) { create(:book_borrow, book: book, user: user) }

        it 'returns the total_books, total_borrowed as 1' do
          subject

          expect(response).to have_http_status(:ok)
          expect(json_response['total_books']).to eq 1
          expect(json_response['total_borrowed']).to eq 1
          expect(json_response['borrowed_due_today']).to eq([])
          expect(json_response['users_with_overdue_books']).to eq([])
        end
      end

      context 'when a member has at least one BookBorrow and has overdue borrows' do
        let!(:book_borrow) do
          create(:book_borrow, book: book, returned: false, user: user,
                               start_date: 15.days.ago, due_date: 1.day.ago)
        end

        it 'returns the users_with_overdue_books' do
          subject

          expect(response).to have_http_status(:ok)

          expect(json_response['total_books']).to eq 1
          expect(json_response['total_borrowed']).to eq 1
          expect(json_response['borrowed_due_today']).to eq([])
          expect(json_response['users_with_overdue_books']).to eq([{ 'email' => user.email }])
        end
      end

      context 'when a member has at least one BookBorrow and is due today' do
        let!(:book_borrow) do
          create(:book_borrow, book: book, returned: false, user: user,
                               start_date: 14.days.ago, due_date: Time.zone.today)
        end

        it 'returns the users_with_overdue_books' do
          subject

          expect(response).to have_http_status(:ok)

          first_overdue = json_response['borrowed_due_today'].first
          expect(first_overdue['start_date']).to eq book_borrow.start_date.strftime('%d/%m/%Y')
          expect(first_overdue['due_date']).to eq book_borrow.due_date.strftime('%d/%m/%Y')
          expect(first_overdue['book']['author']).to eq book.author
          expect(first_overdue['book']['title']).to eq book.title
          expect(first_overdue['book']['isbn']).to eq book.isbn

          expect(json_response['total_books']).to eq 1
          expect(json_response['total_borrowed']).to eq 1
          expect(json_response['users_with_overdue_books']).to eq([])
        end
      end
    end
  end
end
