class Discount < ActiveRecord::Base
  has_many :products

  validates :title, presence: true
  validates :percent, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100 }


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
