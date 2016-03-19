FactoryGirl.define do
  factory :favourite do
    user
    product { create :product }
  end
end
