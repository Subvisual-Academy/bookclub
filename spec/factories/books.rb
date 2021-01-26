FactoryBot.define do
  factory :book do
    title { Faker::Book.title.first(10).strip }
    author { Faker::Book.author }
    synopsis { Faker::Lorem.paragraph_by_chars }
    image { Faker::LoremPixel.image }
    google_id { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
