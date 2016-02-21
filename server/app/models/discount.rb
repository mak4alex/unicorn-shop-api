class Discount < ActiveRecord::Base
  has_many :products

  validates :title, presence: true
  validates :percent, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100 }

end
