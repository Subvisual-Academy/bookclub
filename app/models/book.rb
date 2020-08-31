class Book < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :google_id, presence: true, uniqueness: true

  has_many :book_presentations, dependent: :destroy
  has_many :users, through: :book_presentations

  scope :by_creation_date, -> { order("created_at DESC") }
end
