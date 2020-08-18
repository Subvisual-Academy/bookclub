FactoryBot.define do
  factory :gathering do
    date { Faker::Date.in_date_period }

    trait(:has_special_presentation) { special_presentation { Faker::Verb.base } }

    factory :gathering_with_book_presentations do
      after(:build) do |gathering|
        create(:book_presentation, gathering: gathering)
        create(:book_presentation, :is_special_presentation, gathering: gathering)
      end
    end
  end
end
