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
      expect(response.body).to include(book.isbn)
    end
  end

  describe "POST #create", :vcr do
    it "redirects to books_path on a successful creation" do
      post books_path, params: { book: { isbn: "9781448103690" } }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      post books_path, params: { book: { isbn: "9781448103690" } }

      created_book = Book.last
      expect(created_book.title).to eq("Kafka on the Shore")
      expect(created_book.author).to eq("Haruki Murakami")
      expect(created_book.synopsis).to eq("Kafka Tamura runs away from home at fifteen, under the shadow of his father's dark prophesy. The aging Nakata, tracker of lost cats, who never recovered from a bizarre childhood affliction, finds his pleasantly simplified life suddenly turned upside down. As their parallel odysseys unravel, cats converse with people; fish tumble from the sky; a ghost-like pimp deploys a Hegel-spouting girl of the night; a forest harbours soldiers apparently un-aged since World War II. There is a savage killing, but the identity of both victim and killer is a riddle - one of many which combine to create an elegant and dreamlike masterpiece. 'Wonderful... Magical and outlandish' Daily Mail 'Hypnotic, spellbinding' The Times 'Cool, fluent and addictive' Daily Telegraph")
      expect(created_book.image).to eq("http://books.google.com/books/content?id=L6AtuutQHpwC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")
      expect(created_book.isbn).to eq("9781448103690")
    end

    it "returns bad_request if create is unsuccessful" do
      post books_path, params: { book: { isbn: "no-isbn" } }

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
