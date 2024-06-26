# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard
  def index
    authorize! :read, :dashboard

    current_user.librarian? ? librarian_dashboard : member_dashboard
  end

  private

  def librarian_dashboard
    @total_books = Book.count
    @total_borrowed = BookBorrow.where(returned: false).count
    @borrowed_due_today = BookBorrow.includes(:book).where(returned: false,
                                                           due_date: Time.zone.today)
    @overdue_emails = BookBorrow.includes(:user).overdue.map(&:user_email).uniq
  end

  def member_dashboard
    @book_borrows = current_user.book_borrows
    @overdue_borrows = current_user.book_borrows.overdue
  end
end
