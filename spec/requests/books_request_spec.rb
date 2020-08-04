require "rails_helper"

RSpec.describe "Books", type: :request do
  include ActionView::Helpers::SanitizeHelper
  describe "GET #index" do
    it "displays all books' parameters" do
      list = create_list(:book, 3)

      get books_path

      list.each do |book|
        expect(sanitize(response.body)).to include(book.title)
        expect(sanitize(response.body)).to include(book.author)
        expect(response.body).to include(book.image)
      end
    end
  end

  describe "GET #show" do
    it "displays the given book's parameters" do
      book = create(:book)

      get book_path(book)

      expect(response.body).to include(book.title)
      expect(response.body).to include(book.author)
      expect(response.body).to include(book.synopsis)
      expect(response.body).to include(book.image)
    end
  end

  describe "POST #create", :vcr do
    let(:google_response) do
      VCR.use_cassette("google/book") { GoogleBooks.get_info_by_isbn("9781448103690") }
    end

    it "redirects to books_path on a successful creation" do
      post books_path, params: { isbn: "9781448103690" }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      title = google_response["items"][0]["volumeInfo"]["title"]
      author = google_response["items"][0]["volumeInfo"]["authors"][0]
      synopsis = google_response["items"][0]["volumeInfo"]["description"]
      image = google_response["items"][0]["volumeInfo"]["imageLinks"]["smallThumbnail"]

      post books_path, params: { isbn: "9781448103690" }

      created_book = Book.last
      expect(created_book.title).to eq(title)
      expect(created_book.author).to eq(author)
      expect(created_book.synopsis).to eq(synopsis)
      expect(created_book.image).to eq(image)
    end

    it "returns bad_request if create is unsuccessful" do
      post books_path, params: { isbn: "no-isbn" }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DELETE #destroy" do
    it "redirects to books_path on a successful delete" do
      book = create(:book)

      delete book_path(book)

      expect(response).to redirect_to(books_path)
    end

    it "destroys a book" do
      book = create(:book)

      delete book_path(book)

      expect(Book.count).to eq(0)
    end
  end
end
