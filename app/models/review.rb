class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :rating, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: 0,
                                                     less_than_or_equal_to: 10 }
  validates :user_id, presence: true
  validates :product_id, presence: true


end
