class Api::BooksController < Api::BaseController
  before_action :require_moderator, only: %i[create update destroy]

  def index
    @books = Book.order("created_at DESC").
      page(params[:page]).
      per(params[:per])
  end

  def create
    create_book = CreateBookFromTitleAndAuthor.new(book_params)
    create_book.perform
    @book = create_book.book

    if create_book.successful?
      render :create
    else
      render json: { errors: @book.errors }, status: :bad_request
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(update_book_params)
      render :update
    else
      render json: { errors: @book.errors }, status: :bad_request
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy
  end

  private

  def book_params
    params.require(:book).permit(:title, :author)
  end

  def update_book_params
    params.require(:book).permit(:title, :author, :synopsis, :image)
  end
end
