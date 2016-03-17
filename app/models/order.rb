class Order < ActiveRecord::Base
  include Fetchable

  STATUSES = %w(progress done canceled)
  PAY_TYPES = %w(cash card)
  DELIVERY_TYPES = %w(courier mail self_removal)

  validates :status, inclusion: { in: STATUSES }
  validates :total, presence: true, numericality: { greater_than: 0.0 }
  validates :pay_type, presence: true, inclusion: { in: PAY_TYPES }
  validates :delivery_type, presence: true, inclusion: { in: DELIVERY_TYPES }
  validates :contact, presence: true
  validates_associated :contact
  validates :line_items, presence: true
  validates :comment, length: { maximum: 255 }
  validate :total_sum_set_correctly

  before_validation :set_initial_status


  belongs_to :user

  has_one :contact, dependent: :nullify

  has_many :line_items
  has_many :products, through: :line_items


  def set_initial_status
    self.status ||= 'progress'
  end

  def count_total
    line_items.inject(0) do |sum, line_item|
      sum += line_item.quantity * line_item.product.price
    end
  end

  def total_sum_set_correctly
    errors.add(:total, 'is miscalculated') if total != count_total
  end

  def self.make_order(params, user)
    order = Order.new(total: params[:total], user_id: user.id, pay_type: params[:pay_type], delivery_type: params[:delivery_type])
    params[:line_items].each { |line_item| order.line_items.build(line_item) }
    order.build_contact(params[:contact])
    order
  end

end
