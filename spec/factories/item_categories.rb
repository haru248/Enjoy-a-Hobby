FactoryBot.define do
  factory :item_category do
    sequence(:item_category_name) { |n| "プリセットカテゴリー#{n}" }
    association :preset
  end
end