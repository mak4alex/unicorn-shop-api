FactoryGirl.define do
  factory :order do
    status 'progress'
    total 100
    pay_type 'cash'
    delivery_type 'mail'
    user

    after(:build) do |order|
      order.line_items << build(:line_item, order: order)
      order.contact ||= build(:contact, order: order)
    end
    
  end
end
