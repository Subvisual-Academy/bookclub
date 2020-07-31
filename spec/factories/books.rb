FactoryBot.define do
  factory :book do |_b|
    sequence(:title) { |n| "title #{n}" }
    author { "author" }
    synopsis { "synopsis" }
    image { "image.png" }
  end
end
