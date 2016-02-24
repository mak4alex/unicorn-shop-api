class Category < ActiveRecord::Base
  has_many   :subcategories, class_name: 'Category', foreign_key: 'parent_category_id'
  has_many   :products

  belongs_to :parent,        class_name: 'Category', foreign_key: 'parent_category_id'


  validates :title, presence: true, uniqueness: { case_sensitive: false },
                                    length: { minimum: 3, maximum: 32 }
  validates :description, length: { minimum: 16, maximum: 255 }

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
