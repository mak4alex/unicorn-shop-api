FactoryGirl.define do
  factory :product do
    sequence(:title) { |n| "Product ##{n}" }
    description { FFaker::Lorem.sentence }
    price 192.12
    count 10
    published false

    factory :published_product do
      published true
    end

  end
end
