class Book < ApplicationRecord
  validates :title, presence: true
  validates :google_id, presence: true, uniqueness: true

  has_many :book_presentations, dependent: :destroy
  has_many :users, -> { distinct }, through: :book_presentations

  scope :by_creation_date, -> { order("created_at DESC") }

  def self.search(search)
    return Book.all if search.blank?

    Book.where("title ILIKE ? OR synopsis ILIKE ? OR author ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
