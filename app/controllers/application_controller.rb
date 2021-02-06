class ApplicationController < ActionController::Base
  def not_authenticated
    redirect_to login_path
  end

  def require_moderator
    return if current_user&.moderator

    head :unauthorized
  end
end
