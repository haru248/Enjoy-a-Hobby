FactoryBot.define do
  factory :preset_item do
    sequence(:preset_item_name) { |n| "プリセットアイテム#{n}" }
    association :item_category
  end
end