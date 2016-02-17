FactoryGirl.define do
  factory :line_item do
    product
    order
    quantity 1
    
  end
end
