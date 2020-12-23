class Books::ManualImportController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @book = Book.new(title: params[:title], author: params[:author])
  end

  def create
    @book = Book.new(ensure_book_params)

    if @book.save
      redirect_to books_path, notice: "Book was successfully created."
    else
      flash[:notice] = "Problem: #{@book.errors.messages}"
      redirect_to books_manual_import_new_path
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :synopsis, :image).tap do |params|
      params[:author] = params[:author].presence
      params[:synopsis] = params[:synopsis].presence
      params[:image] = params[:image].presence
    end
  end

  def ensure_book_params
    params = book_params

    params[:google_id] = SecureRandom.hex

    params
  end
end
