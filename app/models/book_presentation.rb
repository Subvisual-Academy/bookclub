class BookPresentation < ApplicationRecord
  belongs_to :gathering
  belongs_to :user
  belongs_to :book
end
