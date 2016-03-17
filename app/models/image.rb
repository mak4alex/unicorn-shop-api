class Image < ActiveRecord::Base
  include Fetchable

  belongs_to :imageable, polymorphic: true

  IMAGEABLE_TYPES = %w( Product Review )

  mount_uploader :file, ImageUploader

  validates :file, presence: true

  validates :imageable_type, presence: true,
            inclusion: { in: IMAGEABLE_TYPES, message: "is not included in #{IMAGEABLE_TYPES}" }

end
