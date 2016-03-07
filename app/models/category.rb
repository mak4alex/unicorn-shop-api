class Category < ActiveRecord::Base
  has_many   :subcategories, class_name: 'Category', foreign_key: 'parent_category_id'
  has_many   :products

  belongs_to :shop
  belongs_to :parent,        class_name: 'Category', foreign_key: 'parent_category_id'


  validates :title, presence: true, uniqueness: { case_sensitive: false },
                                    length: { minimum: 3, maximum: 32 }
  validates :description, length: { minimum: 16, maximum: 255 }
  validates :shop, presence: true, if: 'parent_category_id.nil?'

  include Fetchable


  scope :most_popular, -> do
    select('categories.*, sum(line_items.quantity) as popularity')
        .joins(products: [:line_items])
        .group('categories.id')
        .order('popularity desc')
  end

end
