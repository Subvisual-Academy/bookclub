require "rails_helper"
require "active_support/core_ext/string/filters"

RSpec.describe "Books", type: :request do
  include ActionView::Helpers::SanitizeHelper

  describe "POST #create", :vcr do
    before(:all) do
      login_user(create(:user))
    end

    it "redirects to books_path on a successful creation" do
      post books_path, params: { book: { title: "hard boiled wonderland and the end of the world" } }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      expected_image = "http://books.google.com/books/content?id=3ZgKkumhAywC&printsec"\
                          "=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"

      expected_description = "A narrative particle accelerator that zooms between Wild Turkey Whiskey and Bob Dylan,"\
                            " unicorn skulls and voracious librarians, John Coltrane and Lord Jim. Science fiction, "\
                            "detective story and post-modern manifesto all rolled into one rip-roaring novel,"\
                            " Hard-boiled Wonderland and the End of the World is the tour de force that expanded"\
                            " Haruki Murakami's international following. Tracking one man's descent into the Kafkaesque"\
                            " underworld of contemporary Tokyo, Murakami unites East and West, tragedy and farce,"\
                            " compassion and detachment, slang and philosophy."

      post books_path, params: { book: { title: "hard boiled wonderland and the end of the world" } }

      created_book = Book.last
      expect(created_book.title).to eq("Hard-Boiled Wonderland and the End of the World")
      expect(created_book.author).to eq("Haruki Murakami")
      expect(created_book.image).to eq(expected_image)
      expect(created_book.synopsis).to eq(expected_description)
    end

    it "redirects to new if params are invalid" do
      post books_path, params: { book: { title: "" } }

      expect(Book.last).to be_falsy
      expect(response).to redirect_to(new_book_path)
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
