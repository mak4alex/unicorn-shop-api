class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :products, embed: :ids
end
