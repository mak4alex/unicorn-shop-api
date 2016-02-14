FactoryGirl.define do
  factory :product do
    sequence(:title) { |n| "Product ##{n}" }
    description { FFaker::Lorem.sentence }
    price { rand.round(4) * 100 }
    count { rand(1..20) }
    published false
    category

    factory :published_product do
      published true
    end

  end
end
