class CreateBookFromTitleAndAuthor
  attr_reader :book

  def initialize(book_params)
    @title = book_params[:title]
    @author = book_params[:author]
    @book = Book.new(title: @title, author: @author)
  end

  def perform
    return if @title.blank?

    response = HTTParty.get(url)
    response = response.parsed_response

    fill_in_book_details(response)
  end

  def successful?
    @book.valid? && @book.persisted?
  end

  def reason_for_failure
    if google_id_exists? || title_exists?
      "Book already exists"
    else
      "Book does not exist in the API"
    end
  end

  private

  def google_id_exists?
    @book.errors.messages.key?(:google_id) && @book.errors.messages[:google_id][0].eql?("has already been taken")
  end

  def title_exists?
    @book.errors.messages.key?(:title) && @book.errors.messages[:title][0].eql?("has already been taken")
  end

  def url
    escaped_title = CGI.escape(@title)
    author_query = @author.blank? ? "" : "+inauthor:#{CGI.escape(@author)}"

    "https://www.googleapis.com/books/v1/volumes?q=intitle:#{escaped_title}" + author_query
  end

  def fill_in_book_details(response)
    return if response["totalItems"].zero?

    item = most_similar_item_by_title(response)

    fill_book_from_item(item)

    @book.save
  end

  def most_similar_item_by_title(response)
    # Only the first three items returned by the API are put up to consideration.
    # This happens because the API tends to return various editions of the same book (hence with the same title and author)
    # and FuzzyMatch's behaviour when faced with the same string multiple times is not reliable.
    # Since the API returns the books by order of popularity + geographical location of the request, it has been decided,
    # after testing, that 3 was the number of books for optimal results.
    items = response["items"].first(3)

    fz = FuzzyMatch.new(items, read: proc { |x| x["volumeInfo"]["title"] }) # fuzzy match against the title of each item

    fz.find(@title)
  end

  def fill_book_from_item(item)
    @book.title = title_from_item(item)
    @book.author = author_from_item(item) || @author
    @book.synopsis = synopsis_from_item(item)
    @book.image = image_from_item(item)
    @book.google_id = google_id_from_item(item)
  end

  def title_from_item(item)
    item["volumeInfo"]["title"]
  end

  def author_from_item(item)
    return unless item["volumeInfo"]["authors"]

    item["volumeInfo"]["authors"].join(", ")
  end

  def synopsis_from_item(item)
    return unless item["volumeInfo"]["description"]

    item["volumeInfo"]["description"]
  end

  def image_from_item(item)
    return unless item["volumeInfo"]["imageLinks"]

    item["volumeInfo"]["imageLinks"]["thumbnail"]
  end

  def google_id_from_item(item)
    item["id"]
  end
end
