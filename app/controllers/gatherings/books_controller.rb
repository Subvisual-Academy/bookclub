class Gatherings::BooksController < ApplicationController
  def index
    @gathering = Gathering.find(params[:gathering_id])
    @books = @gathering.books.search(params[:search])
  end
end
