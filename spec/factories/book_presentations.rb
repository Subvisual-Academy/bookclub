FactoryBot.define do
  factory :book_presentation do
    user { create(:user) }
    book { create(:book) }
    special { false }
    gathering { create(:gathering) }

    trait(:is_special_presentation) { special { true } }
  end
end
