class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :user_id, :product_id
end
