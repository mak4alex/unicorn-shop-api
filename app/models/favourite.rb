class Favourite < ActiveRecord::Base
  include Fetchable


  belongs_to :user
  belongs_to :product

  validates :user, presence: true
  validates :product, presence: true

  validates_uniqueness_of :user_id, scope: :product_id


end
