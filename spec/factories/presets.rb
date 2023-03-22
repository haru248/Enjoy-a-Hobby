FactoryBot.define do
  factory :preset do
    sequence(:preset_name) { |n| "プリセット#{n}" }
    association :user
  end
end