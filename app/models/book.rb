class Book < ApplicationRecord
  validates :title, presence: true
  validates :google_id, presence: true, uniqueness: true

  has_many :book_presentations, dependent: :destroy
  has_many :users, -> { distinct }, through: :book_presentations

  scope :by_creation_date, -> { order("created_at DESC") }
  scope :without_book_presentation, -> {
                                      left_outer_joins(:book_presentations).
                                        where(book_presentations: { id: nil })
                                    }

  def self.search(search)
    return Book.all if search.blank?

    Book.where("books.title ILIKE ? OR books.synopsis ILIKE ? OR books.author ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
