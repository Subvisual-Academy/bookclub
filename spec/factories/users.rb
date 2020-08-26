FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "foobar" }
    password_confirmation { "foobar" }
    moderator { false }

    trait(:is_moderator) { moderator { true } }
  end
end
