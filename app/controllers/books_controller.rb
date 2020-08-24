class BooksController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]

  def index
    @books = Book.all.reverse
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      flash.now[:notice] = "Invalid field"
      render :edit, status: :bad_request
    end
  end

  def create
    create_book_from_isbn = CreateBookFromIsbn.new(isbn: params[:book][:isbn])
    @book = create_book_from_isbn.perform

    if create_book_from_isbn.successful?
      redirect_to books_path, notice: "Book was successfully created."
    else
      flash.now[:notice] = "The ISBN is invalid"
      render new_book_path, status: :bad_request
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :synopsis, :image)
  end
end
