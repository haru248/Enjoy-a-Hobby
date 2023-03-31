FactoryBot.define do
  factory :purchase do
    sequence(:purchase_name) { |n| "購入品#{n}" }
    price { 1000 }
    quantity { Faker::Number.between(from: 1, to: 10) }
    association :purchase_list
  end
end