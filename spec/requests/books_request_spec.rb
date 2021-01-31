require "rails_helper"
require "active_support/core_ext/string/filters"

RSpec.describe "Books", type: :request do
  include ActionView::Helpers::SanitizeHelper

  describe "GET #new" do
    it "non-logged users are redirected to login page" do
      get new_book_path

      expect(Book.count).to eq(0)
      expect(response).to redirect_to(login_path)
    end

    it "non-moderators are redirected to login page" do
      login_user(create(:user))

      get new_book_path

      expect(Book.count).to eq(0)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST #create", :vcr do
    it "redirects to books_path on a successful creation" do
      login_user(create(:user, :moderator))

      post books_path, params: {
        book: { title: "hard boiled wonderland and the end of the world" }
      }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      login_user(create(:user, :moderator))
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
      login_user(create(:user, :moderator))

      post books_path, params: { book: { title: "" } }

      expect(Book.last).to be_falsy
      expect(response).to redirect_to(new_book_path)
    end

    it "non-logged users are redirected to login page" do
      post books_path, params: {
        book: { title: "hard boiled wonderland and the end of the world" }
      }

      expect(Book.count).to eq(0)
      expect(response).to redirect_to(login_path)
    end

    it "non-moderators are redirected to login page" do
      login_user(create(:user))

      post books_path, params: {
        book: { title: "hard boiled wonderland and the end of the world" }
      }

      expect(Book.count).to eq(0)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET #edit" do
    it "non-logged users are redirected to login page" do
      book = create(:book)

      get edit_book_path(book)

      expect(response).to redirect_to(login_path)
    end

    it "non-moderators are redirected to login page" do
      login_user(create(:user))
      book = create(:book)

      get edit_book_path(book)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PUT #update" do
    it "updates a book successfully" do
      login_user(create(:user, :moderator))
      book = create(:book)
      new_book_params = attributes_for(:book)

      put book_path(book), params: { book: new_book_params }
      book.reload

      expect(book.title).to eq(new_book_params[:title])
      expect(book.author).to eq(new_book_params[:author])
      expect(book.image).to eq(new_book_params[:image])
      expect(book.synopsis).to eq(new_book_params[:synopsis])
      expect(response).to redirect_to(books_path)
    end

    it "non-logged users are redirected to login page" do
      book = create(:book)
      new_book_params = attributes_for(:book)

      put book_path(book), params: { book: new_book_params }

      expect(Book.last).to eq(book)
      expect(response).to redirect_to(login_path)
    end

    it "non-moderators are redirected to login page" do
      login_user(create(:user))
      book = create(:book)
      new_book_params = attributes_for(:book)

      put book_path(book), params: { book: new_book_params }

      expect(Book.last).to eq(book)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE #destroy" do
    it "redirects to books_path on a successful delete" do
      login_user(create(:user, :moderator))
      book = create(:book)

      delete book_path(book)

      expect(response).to redirect_to(books_path)
    end

    it "destroys a book" do
      login_user(create(:user, :moderator))
      book = create(:book)

      delete book_path(book)

      expect(Book.count).to eq(0)
    end

    it "non-logged users are redirected to login page" do
      book = create(:book)

      delete book_path(book)

      expect(Book.count).to eq(1)
      expect(response).to redirect_to(login_path)
    end

    it "non-moderators are redirected to login page" do
      login_user(create(:user))
      book = create(:book)

      delete book_path(book)

      expect(Book.count).to eq(1)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
