class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  mount_uploader :file, ImageUploader

  validates :file, presence: true
  validates :imageable_id, presence: true
  validates :imageable_type, presence: true

end
