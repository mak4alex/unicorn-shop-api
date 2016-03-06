class CategorySerializer < ActiveModel::Serializer
  attributes :id, :parent_category_id, :title, :description

  has_many :products,      embed: :ids
  has_many :subcategories, embed: :ids
end
