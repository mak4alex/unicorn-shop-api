class CategorySerializer < ActiveModel::Serializer
  attributes :id, :parent_category_id, :title, :description
end
