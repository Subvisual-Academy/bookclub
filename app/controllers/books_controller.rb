class BooksController < ApplicationController
  before_action :require_login, only: %i[new create destroy]

  def index
    @books = Book.sorted_by_creation_date
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    create_book = CreateBookFromTitleAndAuthor.new(params[:book])
    create_book.perform

    if create_book.successful?
      redirect_to books_path, notice: "Book was successfully created."
    else
      @book = create_book.book
      flash.now[:notice] = create_book.reason_for_failure
      render new_book_path, status: :bad_request
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end
end
