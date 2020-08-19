module ApplicationHelper
  def next_gathering_date
    this_month_gathering = find_this_month_gathering

    if Time.zone.today <= this_month_gathering
      this_month_gathering.strftime("%A, %d %B %Y")
    else
      find_next_month_gathering.strftime("%A, %d %B %Y")
    end
  end

  private

  def find_this_month_gathering
    Time.zone.today.at_beginning_of_month.
      next_occurring(:thursday).next_occurring(:thursday).next_occurring(:thursday)
  end

  def find_next_month_gathering
    Time.zone.today.at_beginning_of_month.next_month.
      next_occurring(:thursday).next_occurring(:thursday).next_occurring(:thursday)
  end
end
