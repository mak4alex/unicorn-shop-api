FactoryGirl.define do
  factory :shop do
    title { FFaker::Company.name }
    register_number { FFaker::Identification.ssn }
  end
end
