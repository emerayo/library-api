# frozen_string_literal: true

class BookBorrowsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_and_authorize_book_borrow, only: :update

  # POST /book_borrows
  def create
    authorize! :create, BookBorrow

    @book_borrow = BookBorrow.new(book_borrow_params)

    if @book_borrow.save
      render json: serialize(@book_borrow), status: :created
    else
      render json: { errors: @book_borrow.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /book_borrows/1
  def update
    if @book_borrow.update(update_book_borrow_params)
      render json: serialize(@book_borrow)
    else
      render json: { errors: @book_borrow.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_and_authorize_book_borrow
    authorize! :manage, BookBorrow
    @book_borrow = BookBorrow.find(params[:id])
  end

  def book_borrow_params
    values = params.require(:book_borrow).permit(:due_date, :book_id, :start_date, :user_id)
    values.merge(user_id: current_user.id) if current_user.member?
    values
  end

  def update_book_borrow_params
    params.require(:book_borrow).permit(:returned)
  end

  def serialize(book_borrow)
    BookBorrowSerializer.new(book_borrow).serializable_hash[:data][:attributes]
  end

  def serialize_list(list)
    BookBorrowSerializer.new(list).serializable_hash[:data].pluck(:attributes)
  end
end
