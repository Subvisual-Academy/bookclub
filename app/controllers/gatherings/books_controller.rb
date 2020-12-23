class Gatherings::BooksController < ApplicationController
  def index
    @gathering = Gathering.find(params[:gathering_id])
    @books = @gathering.books.search(params[:search])
    @books = @books.left_joins(:book_presentations).where("book_presentations.user_id": params[:user_id]) if params[:user_id]
  end
end
