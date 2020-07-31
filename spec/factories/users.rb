FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.username }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
