FactoryBot.define do
  factory :inventory_list do
    sequence(:inventory_list_name) { |n| "持ち物リスト#{n}" }
    association :user
  end
end