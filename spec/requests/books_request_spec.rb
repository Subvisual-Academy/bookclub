require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe 'GET index' do
    it 'renders the index template' do
      get books_path
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    it 'renders the show template' do
      book = Book.create(title: 'title', author: 'author', synopsis: 'synopsis', image: 'image.png')
      get book_path(book)
      expect(response).to render_template('show')
    end
  end

  describe 'GET edit' do
    it 'renders the show template' do
      book = Book.create(title: 'title', author: 'author', synopsis: 'synopsis', image: 'image.png')
      get edit_book_path(book)
      expect(response).to render_template('edit')
    end
  end

  describe 'GET new' do
    it 'renders the new template' do
      get new_book_path
      expect(response).to render_template('new')
    end
  end
end
