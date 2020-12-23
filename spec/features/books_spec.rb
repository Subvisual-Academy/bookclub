require "rails_helper"

RSpec.feature "Books", js: true do
  it "renders books without presentation" do
    books = create_list(:book, 3)

    visit books_path

    books.each do |book|
      expect(page).to have_text(book.title)
    end
  end

  it "searches books" do
    hidden_books = create_list(:book, 3)
    book = create(:book, title: "Super Special Title")

    visit books_path(search: book.title)

    expect(page).to have_text(book.title)
    hidden_books.each do |b|
      expect(page).to_not have_text(b.title)
    end
  end

  it "renders books with presentations" do
    gatherings = create_list(:gathering_with_book_presentations, 3)

    visit books_path

    gatherings.each do |gathering|
      gathering.books.each do |book|
        expect(page).to have_text(book.title)
      end
    end
  end

  it "renders just the books of an user" do
    user = create(:user)
    create_list(:book_presentation, 3, user: user)
    create_list(:gathering_with_book_presentations, 3)

    visit user_books_path(user)

    Book.all.each do |book|
      if user.books.include?(book)
        expect(page).to have_text(book.title)
      else
        expect(page).to_not have_text(book.title)
      end
    end
  end
end
