class CacheSweeper < ActionController::Caching::Sweeper
  observe Book, BookPresentation, Gathering

  def after_commit(_record)
    expire_page(gatherings_path)
    expire_page(books_path)
  end
end
