class Discount < ActiveRecord::Base
  belongs_to :shop

  validates :shop,    presence: true
  validates :initial_sum, presence: true, uniqueness: true
  validates :percent, presence: true,
            numericality: { greater_than: 0.0, less_than: 100.0 }

end
