require "rails_helper"

RSpec.describe "Books API", type: :request do
  describe "GET #index" do
    it "renders books" do
      create_list(:book, 3)
      books = Book.order("created_at DESC")

      get api_books_path

      expect(JSON.parse(response.body)).to include("data" => books.as_json)
    end
  end

  describe "POST #create", :vcr do
    it "creates a book" do
      login_user(create(:user, moderator: true))

      expected_image = "http://books.google.com/books/content?id=3ZgKkumhAywC&printsec"\
      "=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
      expected_description = "A narrative particle accelerator that zooms between Wild Turkey Whiskey and Bob Dylan,"\
            " unicorn skulls and voracious librarians, John Coltrane and Lord Jim. Science fiction, "\
            "detective story and post-modern manifesto all rolled into one rip-roaring novel,"\
            " Hard-boiled Wonderland and the End of the World is the tour de force that expanded"\
            " Haruki Murakami's international following. Tracking one man's descent into the Kafkaesque"\
            " underworld of contemporary Tokyo, Murakami unites East and West, tragedy and farce,"\
            " compassion and detachment, slang and philosophy."

      post api_books_path, params: { book: { title: "hard boiled wonderland and the end of the world" } }

      created_book = Book.last
      expect(created_book.title).to eq("Hard-Boiled Wonderland and the End of the World")
      expect(created_book.author).to eq("Haruki Murakami")
      expect(created_book.image).to eq(expected_image)
      expect(created_book.synopsis).to eq(expected_description)
    end

    it "does nothing if a regular user is logged in" do
      book_params = attributes_for(:book)

      post api_books_path, params: { book: book_params }

      expect(response).to have_http_status(:not_found)
      expect(Book.count).to eq(0)
    end

    it "does nothing if no user is logged in" do
      book_params = attributes_for(:book)

      post api_books_path, params: { book: book_params }

      expect(response).to have_http_status(:not_found)
      expect(Book.count).to eq(0)
    end
  end

  describe "PUT #update", :vcr do
    it "updates a book" do
      login_user(create(:user, moderator: true))
      book = create(:book)
      book_params = attributes_for(:book).except(:google_id)

      put api_book_path(book), params: { book: book_params }

      updated_book = Book.last
      expect(updated_book.title).to eq(book_params[:title])
      expect(updated_book.author).to eq(book_params[:author])
      expect(updated_book.image).to eq(book_params[:image])
      expect(updated_book.synopsis).to eq(book_params[:synopsis])
    end

    it "does nothing if a regular user is logged in" do
      login_user
      book = create(:book)

      put api_book_path(book)

      expect(response).to have_http_status(:not_found)
      expect(Book.last).to eq(book)
    end

    it "does nothing if no user is logged in" do
      book = create(:book)

      put api_book_path(book)

      expect(response).to have_http_status(:not_found)
      expect(Book.last).to eq(book)
    end
  end

  describe "DELETE #destroy", :vcr do
    it "updates a book" do
      login_user(create(:user, moderator: true))
      book = create(:book)

      delete api_book_path(book)

      expect(Book.count).to eq(0)
    end

    it "does nothing if a regular user is logged in" do
      login_user
      book = create(:book)

      delete api_book_path(book)

      expect(response).to have_http_status(:not_found)
      expect(Book.count).to eq(1)
    end

    it "does nothing if no user is logged in" do
      book = create(:book)

      delete api_book_path(book)

      expect(response).to have_http_status(:not_found)
      expect(Book.count).to eq(1)
    end
  end
end
