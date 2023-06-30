FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { "This is a product description" }
    category { nil }
    price { 1.0 }
    quantity { 1 }
  end
end
