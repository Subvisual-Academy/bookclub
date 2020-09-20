class ApplicationController < ActionController::Base
  cache_sweeper :cache_sweeper

  def not_authenticated
    redirect_to login_path
  end
end
