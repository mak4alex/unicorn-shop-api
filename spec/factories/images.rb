FactoryGirl.define do
  factory :image do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'product_image.jpg')) }

    factory :product_image do
      association :imageable, factory: :product
    end

    factory :review_image do
      association :imageable, factory: :review
    end

  end
end
