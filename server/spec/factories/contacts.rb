FactoryGirl.define do
  factory :contact do
    email   { FFaker::Internet.email }
    name    { FFaker::Name.name }
    phone   { FFaker::PhoneNumber.phone_number }
    country { FFaker::Address.country }
    city    { FFaker::Address.city }
    address { FFaker::Address.street_address }
    order
  end
end
