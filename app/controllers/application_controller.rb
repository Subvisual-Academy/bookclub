class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning

  def not_authenticated
    redirect_to log_in_path
  end
end
