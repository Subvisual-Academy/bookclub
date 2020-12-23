class Users::BooksController < ApplicationController
  def index
    @user_options = User.all.collect { |u| ["#{u.name} - #{u.books.length}", user_books_path(u.id)] }
    @user_options.prepend(["All users", books_path])
    @user = User.find(params[:user_id])
    @gatherings = @user.gatherings.group_by_year
  end
end
