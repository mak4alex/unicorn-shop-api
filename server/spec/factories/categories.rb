FactoryGirl.define do
  factory :category do
    sequence(:title) { |n| "Category ##{n}" }
    description { FFaker::Lorem.sentence }
  end
end
