FactoryGirl.define do
  factory :image do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'product_image.jpg')) }

    factory :product_image do
      imageable_type 'Product'
      imageable_id 1
    end

    factory :review_image do
      imageable_type 'Review'
    end

  end
end
