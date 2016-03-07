class Contact < ActiveRecord::Base
  belongs_to :order

  validates :email, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :address, presence: true

end
