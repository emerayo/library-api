# frozen_string_literal: true

if current_user.librarian?
  json.total_books @total_books
  json.total_borrowed @total_borrowed

  json.borrowed_due_today do
    json.partial! partial: 'book_borrow', collection: @borrowed_due_today, as: :book_borrow
  end

  json.users_with_overdue_books @overdue_emails do |email|
    json.email email
  end
else
  json.book_borrows do
    json.partial! partial: 'book_borrow', collection: @book_borrows, as: :book_borrow
  end

  json.overdue_borrows do
    json.partial! partial: 'book_borrow', collection: @overdue_borrows, as: :book_borrow
  end
end
