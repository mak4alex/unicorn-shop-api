class Contact < ActiveRecord::Base
  belongs_to :order

  validates :email, presence: true
  validates_format_of :email, with: Devise::email_regexp
  
  validates :name, presence: true
  validates :phone, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :address, presence: true

  def self.sales_stat(params = {})
    params[:sort] ||= 'total_sales desc'
    User.joins(:order)
        .group('email')
        .fetch(params)
        .pluck_h('name', 'email', 'sum(orders.total) as total_sales')
  end
end
