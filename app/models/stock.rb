class Stock < ActiveRecord::Base
  has_many :products

  validates :title, presence: true, uniqueness: true
  validates :percent, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100 }

  include Fetchable

end