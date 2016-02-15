FactoryGirl.define do
  factory :order do
    status 'progress'
    total 100
    pay_type 'cash'
    user
    
  end
end
