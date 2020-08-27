class UserAutocompleteController < ApplicationController
  before_action :force_json, only: :search

  def index; end

  def search
    q = params[:q].downcase
    @userautocomplete = User.where("name ILIKE ?", "%#{q}%").limit(5)
  end

  private

  def force_json
    request.format = :json
  end
end
