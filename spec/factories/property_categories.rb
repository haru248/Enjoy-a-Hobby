FactoryBot.define do
  factory :property_category do
    sequence(:category_name) { |n| "カテゴリー#{n}" }
    association :inventory_list
  end
end