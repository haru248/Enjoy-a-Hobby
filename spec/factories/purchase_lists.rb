FactoryBot.define do
  factory :purchase_list do
    sequence(:purchase_list_name) { |n| "物販購入リスト#{n}" }
    association :user
  end
end