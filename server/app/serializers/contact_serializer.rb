class ContactSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :phone, :country, :city, :address,
             :comment, :created_at, :updated_at, :order_id

end
