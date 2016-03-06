FactoryGirl.define do
  factory :distribution do
    sequence(:title) { |n| "Distribution ##{n}" }
    body { FFaker::Lorem.paragraphs }
    shop nil
  end
end
