require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe 'GET #index' do
    it 'renders the index template' do
      get books_path

      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      book = Book.create(title: 'title', author: 'author', synopsis: 'synopsis', image: 'image.png')

      get book_path(book)

      expect(response).to render_template('show')
    end
  end

  describe 'GET #edit' do
    it 'renders the show template' do
      book = Book.create(title: 'title', author: 'author', synopsis: 'synopsis', image: 'image.png')

      get edit_book_path(book)

      expect(response).to render_template('edit')
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get new_book_path

      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do

    it 'redirects to books_path on a successful creation' do
      book = Book.new(title: 'title', author: 'author', synopsis: 'synopsis', image: 'image.png')

      post books_path, params: { book: { title: book.title, author: book.author, synopsis: book.synopsis, image: book.image}}

      expect(response).to redirect_to(books_path)
    end

    it 'renders the new template if create is unsuccessful' do
      book = Book.new( author: 'author', synopsis: 'synopsis', image: 'image.png')

      post books_path, params: { book: { author: book.author, synopsis: book.synopsis, image: book.image}}

      expect(response).to render_template(:new)
    end
  end

  describe 'PATCH #create' do

    it 'redirects to books_path on on successful patch' do
      book = Book.create( title: 'title', author: 'author',synopsis: 'synopsis', image: 'image.png')

      put book_path(book) , params: { book: { title: 'new_title', author: 'author', synopsis: 'synopsis',
                                                           image: 'image.png'} }

      expect(response).to redirect_to(books_path)
    end

    it 'updates parameter on successful patch' do
      book = Book.create( title: 'title', author: 'author',synopsis: 'synopsis', image: 'image.png')

      put book_path(book) , params: { book: { title: 'new_title', author: 'author', synopsis: 'synopsis',
                                                   image: 'image.png'} }

      expect(Book.find(book.id).title).to eq('new_title')
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to books_path on a successful delete' do
      book = Book.create( title: 'title', author: 'author',synopsis: 'synopsis', image: 'image.png')

      delete book_path(book)

      expect(response).to redirect_to(books_path)
    end
  end

end
