class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :category_id,
             :published, :created_at, :updated_at, :quantity, :weight, :images

  def images
    i = []
    object.images.each do |image|
      i.push({file: image.file.url, thumb: image.file.thumb.url })
    end
    i
  end

end
