class Product < ActiveRecord::Base
  include Fetchable
  include Imageable


  validates :title, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 64 }
  validates :description, presence: true, length: { minimum: 16 }
  validates :quantity, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0.0 }
  validates :category_id, presence: true
  validates :weight, presence: true

  belongs_to :category
  belongs_to :stock

  has_many :images, as: :imageable
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :favourites
  has_many :fans, through: :favourites, source: :user
  has_many :reviews

  scope :filter_by_query, -> (key) do
    if key
      param = "%#{key.downcase}%"
      where('lower(title) LIKE ? OR lower(description) LIKE ?', param, param)
    end
  end

  scope :in_category, -> (category_id) { where( 'category_id = ?', category_id) if category_id  }

  scope :get_by_title, -> (title) do 
    if title
      param = "%#{title.downcase}%"
      where('lower(title) LIKE ?', param)      
    end
  end

  scope :above_or_equal_to_price, -> (price) { where( 'price >= ?', price) if price }
  scope :below_or_equal_to_price, -> (price) { where( 'price <= ?', price) if price }

  scope :above_or_equal_to_quantity, -> (quantity) { where( 'quantity >= ?', quantity) if quantity }
  scope :below_or_equal_to_quantity, -> (quantity) { where( 'quantity <= ?', quantity) if quantity }

  scope :above_or_equal_to_weight, -> (weight) { where( 'weight >= ?', weight) if weight }
  scope :below_or_equal_to_weight, -> (weight) { where( 'weight <= ?', weight) if weight }

  scope :search, -> (params) do
    in_category(params[:category_id])
      .filter_by_query(params[:query])
      .get_by_title(params[:title])
      .above_or_equal_to_price(params[:min_price])
      .below_or_equal_to_price(params[:max_price])
      .above_or_equal_to_quantity(params[:min_quantity])
      .below_or_equal_to_quantity(params[:max_quantity])
      .above_or_equal_to_weight(params[:min_weight])
      .below_or_equal_to_weight(params[:max_weight])
  end


  def decrease_quantity_by (count)
    self.quantity -= count
    save
  end

  def update_rating
    update_attributes(rating: (reviews.average('rating') || 0.0) )
  end

  def self.sales_stat(params = {})
    params[:sort] ||= 'sales_count desc'
    Product
        .joins(:line_items)
        .group('products.id')
        .fetch(params)
        .pluck_h('products.id as id', 'title', 'sum(line_items.quantity) as sales_count')
  end

end
