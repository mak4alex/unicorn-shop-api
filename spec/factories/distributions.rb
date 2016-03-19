FactoryGirl.define do
  factory :distribution do
    sequence(:title) { |n| "Distribution ##{n}" }
    body { FFaker::Lorem.paragraphs }
    shop
  end
end
