class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  has_many :images, as: :imageable

  validates :rating, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: 0,
                                                     less_than_or_equal_to: 10 }
  validates :user_id, presence: true
  validates :product_id, presence: true

  after_save do |review|
    review.product.update_rating
  end

  include Fetchable

  scope :search_by_title, lambda { |key| where('lower(title) LIKE ?', "%#{key.downcase}%") if key }
  scope :search_by_body, lambda { |key| where('lower(body) LIKE ?', "%#{key.downcase}%") if key }

  scope :with_user_id, lambda { |user_id| where( 'user_id = ?', user_id) if user_id  }
  scope :with_product_id, lambda { |product_id| where( 'product_id = ?', product_id) if product_id }

  scope :above_or_equal_to_rating, lambda { |rating| where( 'rating >= ?', rating) if rating }
  scope :below_or_equal_to_rating, lambda { |rating| where( 'rating <= ?', rating) if rating }

  scope :search,
        (lambda do |params|
               search_by_title(params[:title])
              .search_by_body(params[:body])
              .with_user_id(params[:user_id])
              .with_product_id(params[:product_id])
              .above_or_equal_to_rating(params[:min_rating])
              .below_or_equal_to_rating(params[:max_rating])
        end)

  def add_images(image_ids = [])
    Image.where(id: image_ids).find_each do |image|
      image.imageable_id = self.id
      image.save
    end
  end

end
