require "rails_helper"

RSpec.describe "Books", type: :request do
  include ActionView::Helpers::SanitizeHelper
  describe "GET #index" do
    it "displays all books' parameters" do
      list = create_list(:book, 3)

      get books_path

      list.each do |book|
        expect(response_text).to include(book.title)
        expect(response_text).to include(book.author)
        expect(response_text).to include(book.synopsis)
        expect(response.body).to include(book.image)
      end
    end
  end

  describe "GET #show" do
    it "displays the given book's parameters" do
      book = create(:book)

      get book_path(book)

      expect(response_text).to include(book.title)
      expect(response_text).to include(book.author)
      expect(response_text).to include(book.synopsis)
      expect(response.body).to include(book.image)
    end
  end

  describe "POST #create" do
    it "redirects to books_path on a successful creation" do
      book_params = attributes_for(:book)

      post books_path, params: { book: book_params }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      book_params = attributes_for(:book)

      post books_path, params: { book: book_params }

      created_book = Book.last
      expect(created_book.title).to eq(book_params[:title])
      expect(created_book.author).to eq(book_params[:author])
      expect(created_book.synopsis).to eq(book_params[:synopsis])
      expect(created_book.image).to eq(book_params[:image])
    end

    it "returns bad_request if create is unsuccessful" do
      book_params = attributes_for(:book, title: nil)

      post books_path, params: { book: book_params }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PATCH #update" do
    it "redirects to books_path on a successful patch" do
      book = create(:book)

      put book_path(book), params: { book: { title: "new_title", author: "author", synopsis: "synopsis",
                                             image: "image.png" } }

      expect(response).to redirect_to(books_path)
    end

    it "returns bad_request on an unsuccessful patch" do
      book = create(:book)
      book_params = attributes_for(:book, title: nil)

      put book_path(book), params: { book: book_params }

      expect(response).to have_http_status(:bad_request)
    end

    it "updates parameter on successful patch" do
      book = create(:book)
      book_params = attributes_for(:book, title: "new_title")

      put book_path(book), params: { book: book_params }

      book.reload
      expect(book.title).to eq(book_params[:title])
      expect(book.author).to eq(book_params[:author])
      expect(book.synopsis).to eq(book_params[:synopsis])
      expect(book.image).to eq(book_params[:image])
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
