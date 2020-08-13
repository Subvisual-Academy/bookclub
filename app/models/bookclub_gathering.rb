class BookclubGathering < ApplicationRecord
  validates :date, presence: true

  has_many :book_presentations, dependent: :destroy
  accepts_nested_attributes_for :book_presentations, allow_destroy: true, reject_if: proc { |attr|
                                                                                       (attr["user_id"].blank? ||
                                                                                           attr["book_id"].blank?)
                                                                                     }
end
