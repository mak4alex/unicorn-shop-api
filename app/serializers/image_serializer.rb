class ImageSerializer < ActiveModel::Serializer
  attributes :id, :imageable_id, :imageable_type, :image, :thumb

  def image
    object.file.url
  end

  def thumb
    object.file.thumb.url
  end

end
