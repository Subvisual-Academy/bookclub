class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new; end

  def create
    hash = CreateBookFromIsbn.new(isbn: params[:isbn])
    @book = hash.execute

    if @book.save
      redirect_to books_path, notice: "Book was successfully created."

    else
      redirect_to new_book_path, status: :bad_request,
                                 notice: "Book was not successfully created."
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end
end
