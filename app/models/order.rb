class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items
  has_many :products, through: :line_items


  STATUSES = %w(progress done canceled)
  PAY_TYPES = %w(cash card)


  validates :status, inclusion: { in: STATUSES }
  validates :total, presence: true, numericality: { greater_than: 0.0 }
  validates :pay_type, presence: true, inclusion: { in: PAY_TYPES }
  validates :user, presence: true

  validate :total_sum_set_correctly

  before_validation :set_initial_status


  def set_initial_status
    self.status ||= 'progress'
  end

  def count_total
    sum = 0
    line_items.each do |line_item|
      sum += line_item.quantity * line_item.product.price
    end
    sum
  end

  def total_sum_set_correctly
    errors.add(:total, 'is miscalculated') if total != count_total
  end


  def self.make_order(params, user)
    order = Order.new(total: params[:total], user_id: user.id, pay_type: params[:pay_type])
    params[:line_items].each { |line_item| order.line_items.build(line_item) }
    order
  end

end
