class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :synopsis, presence: true
  validates :image, presence: true
end
