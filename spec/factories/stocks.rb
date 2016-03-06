FactoryGirl.define do
  factory :stock do
    title 'Holiday'
    percent 3

    factory :stock_with_products do

      transient do
        count 5
      end

      after(:create) do |stock, evaluator|
        create_list(:product, evaluator.count, stock: stock)
      end

    end

  end
end
