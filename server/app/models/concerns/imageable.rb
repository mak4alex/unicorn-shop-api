module Imageable extend ActiveSupport::Concern

  def add_images(image_ids = [])
    Image.where(id: image_ids).find_each do |image|
      image.imageable_id = self.id
      image.save
    end
  end

end