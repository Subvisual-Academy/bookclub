module GoogleBooks
  def self.get_info_by_isbn(isbn)
    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}")
    response.parsed_response
  end
end
