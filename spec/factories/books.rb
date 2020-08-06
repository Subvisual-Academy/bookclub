FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    synopsis { Faker::Lorem.paragraph_by_chars }
    image { Faker::LoremPixel.image }
    isbn { Faker::Code.isbn }
  end
end
