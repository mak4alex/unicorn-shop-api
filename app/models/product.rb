class Product < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 64 }
  validates :description, presence: true, length: { minimum: 16 }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than: 0.0 }
  validates :category, presence: true
  validates :weight, presence: true

end
