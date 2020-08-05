class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    hash = CreateBookFromIsbn.new(isbn: params[:book][:isbn])
    @book = hash.perform

    if @book.save
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
end
