class CreateBookFromIsbn
  def initialize(isbn: nil)
    @isbn = isbn
    @book = Book.new(isbn: @isbn)
  end

  def perform
    normalized_isbn = StdNum::ISBN.normalize(@isbn)

    return @book if normalized_isbn.nil?

    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=isbn:#{normalized_isbn}")
    response.parsed_response

    fill_in_book_details(response)
  end

  def successful?
    @book.valid? && @book.persisted?
  end

  private

  def fill_in_book_details(response)
    unless response["totalItems"].zero?
      fill_book_from_response(response)
      @book.save
    end
    @book
  end

  def fill_book_from_response(response)
    @book.title = return_title_from_response(response)
    @book.author = return_author_from_response(response)
    @book.synopsis = return_synopsis_from_response(response)
    @book.image = return_image_from_response(response)
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
