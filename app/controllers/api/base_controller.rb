class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_format

  private

  def set_format
    request.format = "json"
  end

  def require_moderator
    require_login

    return if current_user&.moderator

    head :not_found
  end
end
