class CreateBookFromTitleAndAuthor
  def initialize(book_params)
    @title = book_params[:title]
    @author = book_params[:author]
    @book = Book.new(title: @title, author: @author)
  end

  def perform
    return @book if @title.blank?

    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=intitle:#{CGI.escape(@title)}" +
                                (@author.blank? ? "" : "+inauthor:#{CGI.escape(@author)}").to_s)
    response = response.parsed_response

    fill_in_book_details(response)
  end

  def successful?
    @book.valid? && @book.persisted?
  end

  def reason_for_no_success
    return "Book already exists" if @book.errors.messages.key?(:google_id) &&
      @book.errors.messages[:google_id][0].eql?("has already been taken")

    "Book does not exist in the API"
  end

  private

  def fill_in_book_details(response)
    unless response["totalItems"].zero?
      item = if response["totalItems"].to_i >= 2
               most_similar_item_by_title(response)
             else
               response["items"][0]
             end
      fill_book_from_item(item)
      @book.save
    end
    @book
  end

  def most_similar_item_by_title(response)
    items = response["items"]

    if string_similarity_index(items[0]["volumeInfo"]["title"], @title) >=
        string_similarity_index(items[1]["volumeInfo"]["title"], @title)
      items[0]
    else
      items[1]
    end
  end

  # compares each character of the returned title against the one prompted by the user
  def string_similarity_index(string1, string2)
    longer = [string1.size, string2.size].max
    same = string1.each_char.zip(string2.each_char).count { |a, b| a != b }
    (longer - same) / string1.size.to_f
  end

  def fill_book_from_item(item)
    @book.title = return_title_from_item(item)
    @book.author = return_author_from_item(item)
    @book.synopsis = return_synopsis_from_item(item)
    @book.image = return_image_from_item(item)
    @book.google_id = return_google_id_from_item(item)
  end

  def return_title_from_item(item)
    item["volumeInfo"]["title"]
  end

  def return_author_from_item(item)
    return "Unavailable" unless item["volumeInfo"]["authors"]

    item["volumeInfo"]["authors"][0]
  end

  def return_synopsis_from_item(item)
    return "Unavailable" unless item["volumeInfo"]["description"]

    item["volumeInfo"]["description"]
  end

  def return_image_from_item(item)
    return "Unavailable" unless item["volumeInfo"]["imageLinks"]

    item["volumeInfo"]["imageLinks"]["thumbnail"]
  end

  def return_google_id_from_item(item)
    item["id"]
  end
end
