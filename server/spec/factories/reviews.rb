FactoryGirl.define do
  factory :review do
    title 'I am happy'
    body 'Product review here'
    rating { rand(0..10) }
    user
    product
  end
end
