class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include Fetchable


  SEXES = %w(male female)
  ROLES = %w(guest customer manager)

  attr_accessor :total

  before_validation do
    self.uid = email if uid.blank?
    self.provider = 'email' if provider.blank?
  end

  has_many :orders
  has_many :favourites
  has_many :favourite_products, through: :favourites, source: :product

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: Devise::email_regexp
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :sex, inclusion: { in: SEXES }, unless: 'sex.nil?'


  def manager?
    self.role == 'manager'
  end

  def self.sales_stat(params = {})
    params[:sort] ||= 'total_sales desc'
    User.joins(:orders)
        .group('users.id')
        .fetch(params)
        .pluck_h('users.id as id', 'name', 'email', 'sum(orders.total) as total_sales')
  end

end
