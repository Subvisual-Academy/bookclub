require 'rails_helper'

RSpec.describe "BookByHands", type: :request do

    describe "GET #new" do
        it "redirects non logged user to login page" do
        get new_books_by_hand_path

        expect(response).to redirect_to(login_path)
        end
    end

    it "displays the gathering form for logged in users" do
        user = create(:user)
        login_user(user)

        get new_books_by_hand_path

        expect(response_text).to include("Title")
        expect(response_text).to include("Author")
        expect(response_text).to include("Synopsis")
        expect(response_text).to include("Image")
    end

    describe "POST #create", :vcr do
        before(:all) do
            login_user(create(:user))
        end

    it "redirects to books_path on a successful creation" do
        post books_by_hand_index_path, params: { book: { title: "Hard-Boiled Wonderland and the End of the World", author: "Haruki Murakami" } }
        
        expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
        post books_by_hand_index_path, params: { book: { title: "Hard-Boiled Wonderland and the End of the World", author: "Haruki Murakami" } }

        created_book = Book.last
        expect(created_book.title).to eq("Hard-Boiled Wonderland and the End of the World")
        expect(created_book.author).to eq("Haruki Murakami")
        expect(created_book.synopsis).to eq("Unavailable")
        expect(created_book.image).to eq("https://www.ajnorfield.com/wp-content/uploads/2018/03/question_mark-book-cover.jpg")
    end

    it "returns bad_request if create is unsuccessful" do
        post books_path, params: { book: { author: "" } }

        expect(response).to have_http_status(:bad_request)
    end
  end
end
