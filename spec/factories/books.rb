FactoryBot.define do
  factory :book do
    sequence(:title) { Faker::Book.title }
    author { Faker::Book.author }
    synopsis { "synopsis" }
    image { "image.png" }
    isbn { "1400079276" }
  end
end
