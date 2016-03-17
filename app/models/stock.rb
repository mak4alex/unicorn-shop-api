class Stock < ActiveRecord::Base
  include Fetchable


  validates :title, presence: true, uniqueness: true
  validates :percent, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100 }

  has_many :products

end
