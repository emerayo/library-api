# frozen_string_literal: true

json.id book_borrow.id
json.user_id book_borrow.user_id
json.book_id book_borrow.book_id
json.start_date book_borrow.start_date.strftime('%d/%m/%Y')
json.due_date book_borrow.due_date.strftime('%d/%m/%Y')
json.returned book_borrow.returned

json.book do
  json.id book_borrow.book.id
  json.author book_borrow.book.author
  json.title book_borrow.book.title
  json.genre book_borrow.book.genre
  json.isbn book_borrow.book.isbn
end
