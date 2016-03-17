class StockSerializer < ActiveModel::Serializer
  attributes :id, :title, :percent

  has_many :products, embed: :ids
end
