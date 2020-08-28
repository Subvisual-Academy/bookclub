class AutocompleteController < ApplicationController
  before_action :force_json, only: %i[search_user search_book]

  def index; end

  def search_user
    q = params[:q].downcase
    @userautocomplete = User.where("name ILIKE ?", "%#{q}%").limit(10)
  end

  def search_book
    q = params[:q].downcase
    @bookautocomplete = Book.where("title ILIKE ?", "%#{q}%").limit(10)
  end

  private

  def force_json
    request.format = :json
  end
end
