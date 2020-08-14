module GatheringHelper
  def filter_by_year(gatherings, year)
    gatherings.select { |gathering| gathering.date.year == year }.
      sort_by { |gathering| gathering.date.month }.reverse
  end
end
