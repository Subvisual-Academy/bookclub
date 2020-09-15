class Book < ApplicationRecord
  validates :title, presence: true
  validates :google_id, presence: true, uniqueness: true

  has_many :book_presentations, dependent: :destroy
  has_many :users, through: :book_presentations

  scope :by_creation_date, -> { order("created_at DESC") }

  def self.search(search)
    if search.blank?
      Book.all
    else
      Book.where("title ILIKE ? OR synopsis ILIKE ? OR author ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
    end
  end
end
