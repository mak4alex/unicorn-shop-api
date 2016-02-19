FactoryGirl.define do
  factory :product do
    sequence(:title) { |n| "Product ##{n}" }
    description { FFaker::Lorem.sentence }
    price 100
    quantity { rand(1..20) }
    published false
    weight { rand.round(5) * 1000 }
    category

    factory :published_product do
      published true
    end

  end
end
