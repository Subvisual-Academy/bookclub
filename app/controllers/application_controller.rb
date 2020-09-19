class ApplicationController < ActionController::Base
  self.page_cache_directory = -> { Rails.root.join("public/page-cache") }
  cache_sweeper :cache_sweeper

  def not_authenticated
    redirect_to login_path
  end
end
