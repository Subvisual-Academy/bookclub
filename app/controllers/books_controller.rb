class BooksController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  protect_from_forgery except: :show

  def index
    @search_param = params[:search]
    @gatherings = eligible_gatherings(@search_param).group_by_year
    @books_without_presentation = Book.without_book_presentation.search(@search_param)
    @user_options = User.all.collect { |u| ["#{u.name} - #{u.books.length}", user_books_path(u.id)] }.prepend(["All users", books_path])
  end

  def show
    @book = Book.find(params[:id])
    @presenting_users = @book.users

    render layout: false
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
      flash[:notice] = create_book.reason_for_failure
      redirect_to new_book_path
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to books_path, notice: "Book was successfully updated."
    else
      flash[:notice] = "Invalid field"
      redirect_to edit_book_path
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def search_params
    params.permit(:user_id, :search)
  end

  def book_params
    params.require(:book).permit(:title, :author, :synopsis, :image)
  end

  def eligible_gatherings(search)
    return Gathering.all unless search

    ids = BookPresentation.joins(:book).
      where("books.title ILIKE ? OR books.synopsis ILIKE ? OR books.author ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").
      pluck(:gathering_id).
      uniq

    Gathering.where(id: ids)
  end
end
