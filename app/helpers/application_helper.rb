module ApplicationHelper
  def next_gathering_date
    this_month_gathering = find_this_month_gathering

    if Time.zone.today <= this_month_gathering
      this_month_gathering
    else
      find_next_month_gathering
    end
  end

  private

  def find_this_month_gathering
    date = Time.zone.today.at_beginning_of_month.
      next_occurring(:thursday).next_occurring(:thursday)

    return date if date.at_beginning_of_month.wday == 4 # if the month already started on a thursday

    date.next_occurring(:thursday)
  end

  def find_next_month_gathering
    date = Time.zone.today.at_beginning_of_month.next_month.
      next_occurring(:thursday).next_occurring(:thursday)

    return date if date.at_beginning_of_month.wday == 4 # if the month already started on a thursday

    date.next_occurring(:thursday)
  end
end
