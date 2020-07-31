class ApplicationController < ActionController::Base
  def not_authenticated
    redirect_to log_in_path
  end
end
