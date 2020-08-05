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

      expect(sanitize(response.body)).to include(book.title)
      expect(sanitize(response.body)).to include(book.author)
      expect(sanitize(response.body)).to include(book.synopsis)
      expect(sanitize(response.body)).to include(book.image)
    end
  end

  describe "POST #create", :vcr do
    let(:api_created_book) do
      VCR.use_cassette("google/book") do
        hash = CreateBookFromIsbn.new(isbn: 9781448103690)
        hash.execute
      end
    end

    it "redirects to books_path on a successful creation" do
      post books_path, params: { isbn: "9781448103690" }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      post books_path, params: { isbn: "9781448103690" }

      created_book = Book.last
      expect(created_book.title).to eq(api_created_book.title)
      expect(created_book.author).to eq(api_created_book.author)
      expect(created_book.synopsis).to eq(api_created_book.synopsis)
      expect(created_book.image).to eq(api_created_book.image)
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
