class Book < ApplicationRecord
  validates :title, presence: true

  validates :author, presence: true

  validates :synopsis, presence: true

  validates :image, presence: true

  validates :google_id, presence: true
  validates :google_id, uniqueness: true

  has_many :book_presentations, dependent: :destroy
  has_many :users, through: :book_presentations
end
