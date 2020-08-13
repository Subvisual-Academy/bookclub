FactoryBot.define do
  factory :bookclub_gathering do
    date { Faker::Date.in_date_period }

    trait(:has_special_presentation) { special_presentation { Faker::Verb.base } }

    factory :bookclub_gathering_with_book_presentations do
      after(:build) do |bookclub_gathering|
        create(:book_presentation, bookclub_gathering: bookclub_gathering)
        create(:book_presentation, :belong_to_special_presentation, bookclub_gathering: bookclub_gathering)
      end
    end
  end
end
