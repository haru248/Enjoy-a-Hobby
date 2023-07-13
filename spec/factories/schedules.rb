FactoryBot.define do
  factory :schedule do
    sequence(:schedule_name) { |n| "スケジュール#{n}" }
    association :user
  end
end