FactoryBot.define do
  factory :book_presentation do
    user { create(:user) }
    book { create(:book) }
    belongs_special_presentation { false }
    gathering { create(:gathering) }

    trait(:belong_to_special_presentation) { belongs_special_presentation { true } }
  end
end
