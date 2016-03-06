class Shop < ActiveRecord::Base

  validates :title,           presence: true,
                              uniqueness: { case_sensitive: false }
  validates :register_number, presence: true, length: { in: 8..32 },
                              uniqueness: { case_sensitive: false }

  has_many :discounts
  has_many :distributions
  has_many :categories

end
