class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :synopsis, presence: true
  validates :image, presence: true
  validates :isbn, presence: true

  has_many :book_presentations, dependent: :destroy
  has_many :users, through: :book_presentations
end
