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
    end
  end

  describe "POST #create", :vcr do
    before(:all) do
      login_user(create(:user))
    end

    it "redirects to books_path on a successful creation" do
      post books_path, params: { book: { title: "hard boiled wonderland and the end of the world" } }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      post books_path, params: { book: { title: "hard boiled wonderland and the end of the world" } }

      created_book = Book.last
      expect(created_book.title).to eq("Hard-Boiled Wonderland and the End of the World")
      expect(created_book.author).to eq("Haruki Murakami")
      expect(created_book.image).to eq("http://books.google.com/books/content?id=3ZgKkumhAywC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")
      expect(created_book.synopsis).to eq("A narrative particle accelerator that zooms between Wild Turkey Whiskey and Bob Dylan, unicorn skulls and voracious librarians, John Coltrane and Lord Jim. Science fiction, detective story and post-modern manifesto all rolled into one rip-roaring novel, Hard-boiled Wonderland and the End of the World is the tour de force that expanded Haruki Murakami's international following. Tracking one man's descent into the Kafkaesque underworld of contemporary Tokyo, Murakami unites East and West, tragedy and farce, compassion and detachment, slang and philosophy.")
    end

    it "returns bad_request if create is unsuccessful" do
      post books_path, params: { book: { title: "" } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DELETE #destroy" do
    before(:all) do
      login_user(create(:user))
    end

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
