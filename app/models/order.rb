class Order < ActiveRecord::Base
  belongs_to :user


  STATUSES = %w(progress done canceled)
  PAY_TYPES = %w(cash card)


  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :total, presence: true, numericality: { greater_than: 0.0 }
  validates :pay_type, presence: true, inclusion: { in: PAY_TYPES }
  validates :user, presence: true

end
