FactoryGirl.define do
  factory :discount do
    title 'Holiday'
    percent 3

    factory :discount_with_products do

      transient do
        count 5
      end

      after(:create) do |discount, evaluator|
        create_list(:product, evaluator.count, discount: discount)
      end

    end

  end
end
