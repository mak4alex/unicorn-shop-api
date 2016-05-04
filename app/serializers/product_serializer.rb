class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :category_id, :rating,
             :published, :created_at, :updated_at, :quantity, :weight, :images

  def images
    host = ActionController::Base.asset_host
    object.images.map do |image|
      { file: host + image.file.url, thumb: host + image.file.thumb.url }
    end
  end
end
