class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true

  validates :email, presence: true
  validates :email, uniqueness: true

  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :book_presentations, dependent: :destroy
  has_many :books, -> { distinct }, through: :book_presentations
end
