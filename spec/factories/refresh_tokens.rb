FactoryBot.define do
  factory :refresh_token do
    token { "MyString" }
    admin { nil }
    expire_at { "2023-06-23 06:03:53" }
  end
end
