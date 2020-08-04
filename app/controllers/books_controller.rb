class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new; end

  def create
    response = GoogleBooks.get_info_by_isbn(params[:isbn])

    if response["totalItems"].zero?
      flash[:alert] = "Nonexistent ISBN"
      render :new, status: :bad_request
    else
      title = response["items"][0]["volumeInfo"]["title"]
      author = response["items"][0]["volumeInfo"]["authors"][0]
      synopsis = response["items"][0]["volumeInfo"]["description"]
      image = response["items"][0]["volumeInfo"]["imageLinks"]["smallThumbnail"]
      @book = Book.new(title: title, author: author, synopsis: synopsis, image: image)

      if @book.save
        redirect_to books_path, notice: "Book was successfully created."
      else
        render :new, status: :bad_request
      end
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end
end
