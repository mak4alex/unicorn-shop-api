FactoryGirl.define do
  factory :line_item do
    product
    order
    quantity { rand(1..10) }
    
  end
end
