FactoryBot.define do
  factory :property do
    sequence(:property_name) { |n| "持ち物#{n}" }
    association :property_category
  end
end