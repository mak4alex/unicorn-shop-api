class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :order, presence: true
  validates :product, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true,
                                                       greater_than_or_equal_to: 1 }

end