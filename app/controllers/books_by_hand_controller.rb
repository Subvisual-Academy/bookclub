class BooksByHandController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(ensure_book_params)

    if @book.save
      redirect_to books_path, notice: "Book was successfully created."
    else
      flash.now[:notice] = "Problem: #{@book.errors.messages}"
      render new_books_by_hand_path, status: :bad_request
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :synopsis, :image)
  end

  def ensure_book_params
    params = book_params

    params[:google_id] = SecureRandom.hex
    params[:synopsis] = "Unavailable" if params[:synopsis].blank?
    params[:image] = "https://www.ajnorfield.com/wp-content/uploads/2018/03/question_mark-book-cover.jpg" if params[:image].blank?
    
    params
  end
end
