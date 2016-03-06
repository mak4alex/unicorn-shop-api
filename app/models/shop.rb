class Shop < ActiveRecord::Base

  validates :title,           presence: true, length: { in: 3..32 }, uniqueness: true
  validates :register_number, presence: true, length: { in: 8..32 }, uniqueness: true

  has_many :discounts
  has_many :distributions
  has_many :categories

end
