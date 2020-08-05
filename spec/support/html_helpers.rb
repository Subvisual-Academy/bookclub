module HtmlHelpers
  def response_text
    Nokogiri::HTML(response.body).text
  end
end
