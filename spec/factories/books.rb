FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "title-#{n}" }
    author { Faker::Book.author }
    synopsis { Faker::Lorem.paragraph_by_chars }
    image { Faker::LoremPixel.image }
    google_id { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
