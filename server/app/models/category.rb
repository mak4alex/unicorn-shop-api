class Category < ActiveRecord::Base
  has_many :products

  validates :title, presence: true, uniqueness: { case_sensitive: false },
                                    length: { minimum: 3, maximum: 32 }
  validates :description, presence: true,length: { minimum: 16 }

end
