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
      redirect_to new_book_path, status: :bad_request,
                                 notice: "Book was not successfully created."
    else
      @book = create_book_from_response(response)

      @book.save

      redirect_to books_path, notice: "Book was successfully created."
    end
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def create_book_from_response(response)
    Book.new(title: return_title_from_response(response),
             author: return_author_from_response(response),
             synopsis: return_synopsis_from_response(response),
             image: return_image_from_response(response))
  end

  def return_title_from_response(response)
    response["items"][0]["volumeInfo"]["title"]
  end

  def return_author_from_response(response)
    response["items"][0]["volumeInfo"]["authors"][0]
  end

  def return_synopsis_from_response(response)
    response["items"][0]["volumeInfo"]["description"]
  end

  def return_image_from_response(response)
    response["items"][0]["volumeInfo"]["imageLinks"]["smallThumbnail"]
  end
end
