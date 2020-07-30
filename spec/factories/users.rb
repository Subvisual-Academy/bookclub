FactoryBot.define do
  factory :user do
    name {"name"}
    email {"email@email_provider.domain"}
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
