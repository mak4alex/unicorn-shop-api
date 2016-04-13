class CategoryMenuSerializer < ActiveModel::Serializer
	attributes :id, :title
	has_many :subcategories
end
