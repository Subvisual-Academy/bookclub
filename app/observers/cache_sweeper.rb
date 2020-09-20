class CacheSweeper < ActionController::Caching::Sweeper
  observe Book, BookPresentation, Gathering

  def after_commit(_record)
    return unless @controller

    expire_action(controller: "gatherings", action: "index")
    expire_action(controller: "books", action: "index")
  end
end
