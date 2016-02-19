FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password '12345678'
    password_confirmation '12345678'
    role 'customer'

    trait :manager do
      role 'manager'
    end

    trait :guest do
      role 'guest'
    end

  end
end
