class AutocompleteController < ApplicationController
  before_action :force_json, only: :search_user

  def index; end

  def search_user
    q = params[:q].downcase
    @userautocomplete = User.where("name ILIKE ?", "%#{q}%").limit(10)
  end

  private

  def force_json
    request.format = :json
  end
end
