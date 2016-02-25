class Product < ActiveRecord::Base

  belongs_to :category
  belongs_to :discount

  has_many :images, as: :imageable
  has_many :line_items
  has_many :orders, through: :line_items

  validates :title, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 64 }
  validates :description, presence: true, length: { minimum: 16 }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than: 0.0 }
  validates :category_id, presence: true
  validates :weight, presence: true

  scope :filter_by_title,
        (lambda do |keyword|
          where('lower(title) LIKE ?', "%#{keyword.downcase}%") if keyword
        end)

  scope :in_category, lambda { |category_id| where( 'category_id = ?', category_id) if category_id  }

  scope :above_or_equal_to_price, lambda { |price| where( 'price >= ?', price) if price }
  scope :below_or_equal_to_price, lambda { |price| where( 'price <= ?', price) if price }

  scope :above_or_equal_to_quantity, lambda { |quantity| where( 'quantity >= ?', quantity) if quantity }
  scope :below_or_equal_to_quantity, lambda { |quantity| where( 'quantity <= ?', quantity) if quantity }

  scope :above_or_equal_to_weight, lambda { |weight| where( 'weight >= ?', weight) if weight }
  scope :below_or_equal_to_weight, lambda { |weight| where( 'weight <= ?', weight) if weight }

  scope :search,
        (lambda do |params|
          in_category(params[:category_id])
              .filter_by_title(params[:title])
              .above_or_equal_to_price(params[:min_price])
              .below_or_equal_to_price(params[:max_price])
              .above_or_equal_to_quantity(params[:min_quantity])
              .below_or_equal_to_quantity(params[:max_quantity])
              .above_or_equal_to_weight(params[:min_weight])
              .below_or_equal_to_weight(params[:max_weight])
        end)


  include Fetchable

  def add_images(image_ids = [])
    Image.find(image_ids).each do |image|
      image.imageable_id = self.id
      image.save
    end
  end

end
