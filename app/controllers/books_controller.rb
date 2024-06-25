# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :find_book, only: %i[update destroy]

  has_scope :by_author
  has_scope :by_title
  has_scope :by_genre

  # GET /books
  def index
    @books = Book.all

    render json: serialize_list(@books)
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: serialize(@book), status: :created
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1/edit
  def update
    if @book.update(book_params)
      render json: serialize(@book)
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    head :no_content
  end

  # GET /books
  def search
    @books = apply_scopes(Book).all
    render json: serialize_list(@books)
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:author, :copies, :genre, :isbn, :title)
  end

  def serialize(book)
    BookSerializer.new(book).serializable_hash[:data][:attributes]
  end

  def serialize_list(list)
    BookSerializer.new(list).serializable_hash[:data].pluck(:attributes)
  end
end
