class BooksController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]

  def index
    @selected_user = User.find_by(id: params[:user_id])
    @search_param = params[:search]
    @gatherings = Gathering.group_by_year
    @books = retrieve_books(@selected_user, @search_param)
    @users = User.order(:name).all
  end

  def new
    @book = Book.new(title: params[:title], author: params[:author])
  end

  def edit
    @book = Book.find(params[:id])
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

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to books_path, notice: "Book was successfully updated."
    else
      flash.now[:notice] = "Invalid field"
      render :edit, status: :bad_request
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

  def retrieve_books(selected_user, search_param)
    if search_param
      Book.search(search_param)
    elsif selected_user
      selected_user.books.distinct
    else
      Book.by_creation_date
    end
  end
end
