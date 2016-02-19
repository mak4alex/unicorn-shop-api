FactoryGirl.define do
  factory :order do
    status 'progress'
    total 100
    pay_type 'cash'
    user

    after(:build) do |order|
      order.line_items << create(:line_item, order: order)
    end
    
  end
end
