class BooksController < ApplicationController
  before_action :require_login, only: %i[new create destroy]

  def index
    @books = Book.order("created_at DESC")
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    create_book_from_t_and_a = CreateBookFromTitleAndAuthor.new(params[:book])
    @book = create_book_from_t_and_a.perform

    if create_book_from_t_and_a.successful?
      redirect_to books_path, notice: "Book was successfully created."
    else
      flash.now[:notice] = create_book_from_t_and_a.reason_for_no_success
      render new_book_path, status: :bad_request
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end
end
