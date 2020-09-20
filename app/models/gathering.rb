class Gathering < ApplicationRecord
  validates :date, presence: true

  has_many :book_presentations, dependent: :destroy
  has_many :books, -> { distinct }, through: :book_presentations
  accepts_nested_attributes_for :book_presentations, allow_destroy: true, reject_if: proc { |attr|
                                                                                       (attr["user_id"].blank? ||
                                                                                           attr["book_id"].blank?)
                                                                                     }
  class << self
    def group_by_year
      Gathering.select("extract(year from date) as year, *").
        order("date desc").
        group_by(&:year).
        transform_keys(&:round)
    end

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
end
