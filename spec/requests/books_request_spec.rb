require "rails_helper"

RSpec.describe "Books", type: :request do
  describe "GET #index" do
    it "displays all books' parameters" do
      list = create_list(:book, 3)

      get books_path

      list.each do |book|
        expect(response.body).to include(book.title)
        expect(response.body).to include(book.author)
        expect(response.body).to include(book.synopsis)
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

  describe "POST #create" do
    it "redirects to books_path on a successful creation" do
      book = build(:book)

      post books_path, params: { book: { title: book.title, author: book.author, synopsis: book.synopsis, image: book.image } }

      expect(response).to redirect_to(books_path)
    end

    it "renders the new template if create is unsuccessful" do
      book = build(:book)

      post books_path, params: { book: { author: book.author, synopsis: book.synopsis, image: book.image } }

      expect(response).to render_template("new")
    end
  end


  describe "PATCH #create" do
    it "redirects to books_path on a successful patch" do
      book = create(:book)

      put book_path(book), params: { book: { title: "new_title", author: "author", synopsis: "synopsis",
                                             image: "image.png" } }

      expect(response).to redirect_to(books_path)
    end

    it "renders the edit template on an unsuccessful patch" do
      book = create(:book)

      put book_path(book), params: { book: { synopsis: "" } }

      expect(response).to render_template("edit")
    end

    it "updates parameter on successful patch" do
      book = create(:book)

      put book_path(book), params: { book: { title: "new_title", author: "author", synopsis: "synopsis",
                                             image: "image.png" } }

      expect(Book.find(book.id).title).to eq("new_title")
    end
  end

  describe "DELETE #destroy" do
    it "redirects to books_path on a successful delete" do
      book = create(:book)

      delete book_path(book)

      expect(response).to redirect_to(books_path)
    end
  end
end
