FactoryGirl.define do
  factory :category do
    sequence(:title) { |n| "Category ##{n}" }
    description { FFaker::Lorem.sentence }


    factory :category_with_subcategories do

      transient do
        count 5
      end

      after(:create) do |category, evaluator|
        create_list(:category, evaluator.count, parent: category)
      end

    end

    factory :category_with_products do

      transient do
        count 5
      end

      after(:create) do |category, evaluator|
        create_list(:product, evaluator.count, category: category)
      end

    end

  end
end
