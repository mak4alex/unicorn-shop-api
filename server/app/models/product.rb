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


  scope :sort, lambda { |params | order(params[:sort]) if params[:sort].present? }
  scope :pagination,
        (lambda do |params|
          if params[:page].present? || params[:per_page].present?
            params[:page] ||= 1
            params[:per_page] ||= 10
            page(params[:page]).per(params[:per_page])
          end
        end)

  scope :fetch, lambda { |params|  sort(params).pagination(params) }

end
