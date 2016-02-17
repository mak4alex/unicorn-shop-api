class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total, :user_id, :pay_type, :created_at, :updated_at
end
