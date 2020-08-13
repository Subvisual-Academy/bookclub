module BookclubGatheringHelper
  def filter_by_year(bookclub_gatherings, year)
    bookclub_gatherings.select { |gathering| gathering.date.year == year }.sort_by { |gathering| gathering.date.month }.reverse
  end
end
