FactoryGirl.define do
  factory :admin do
    email { FFaker::Internet.email }
    password '12345678'
    password_confirmation '12345678'
  end
end