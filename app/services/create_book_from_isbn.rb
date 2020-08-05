class CreateBookFromIsbn
  def initialize(isbn: nil)
    @isbn = isbn
  end

  def execute
    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=isbn:#{@isbn}")
    response.parsed_response

    if response["totalItems"].zero?
      Book.new
    else
      create_book_from_response(response)
    end
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
