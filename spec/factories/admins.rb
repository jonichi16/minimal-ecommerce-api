FactoryBot.define do
  factory :admin do
    sequence(:name) { |n| "Admin #{n}" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password" }
  end
end
