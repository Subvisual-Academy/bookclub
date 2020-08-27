require "rails_helper"

RSpec.describe "BookByHands", type: :request do
  describe "GET #new" do
    it "redirects non logged user to login page" do
      get books_manual_import_new_path

      expect(response).to redirect_to(login_path)
    end
  end

  it "displays the gathering form for logged in users" do
    user = create(:user)
    login_user(user)

    get books_manual_import_new_path

    expect(response_text).to include("Title")
    expect(response_text).to include("Author (optional)")
    expect(response_text).to include("Synopsis (optional)")
    expect(response_text).to include("Link to book cover (optional)")
  end

  describe "POST #create", :vcr do
    before(:all) do
      login_user(create(:user))
    end

    it "redirect to API creation and carry the params when prompted" do
      params = { redirect_to_API: "Create using API",
                 book: { title: Faker::Name, author: Faker::Book.author } }

      post books_manual_import_path, params: params

      expect(response).to redirect_to(new_book_path(title: params[:book][:title],
                                                    author: params[:book][:author]))
    end

    it "redirects to books_path on a successful creation" do
      title = "Hard-Boiled Wonderland and the End of the World"

      post books_manual_import_path, params: { book: { title: title } }

      expect(response).to redirect_to(books_path)
    end

    it "creates a book with the correct params" do
      title = "Hard-Boiled Wonderland and the End of the World"
      author = "Haruki Murakami"
      synopsis = "sample_sinopsis"
      image_url = "https://www.ajnorfield.com/wp-content/uploads/2018/03/question_mark-book-cover.jpg"

      post books_manual_import_path, params: { book: { title: title, author: author,
                                                       synopsis: synopsis, image: image_url } }

      created_book = Book.last
      expect(created_book.title).to eq(title)
      expect(created_book.author).to eq(author)
      expect(created_book.synopsis).to eq(synopsis)
      expect(created_book.image).to eq(image_url)
    end

    it "returns bad_request if create is unsuccessful" do
      post books_path, params: { book: { author: "" } }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
