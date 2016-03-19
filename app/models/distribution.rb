class Distribution < ActiveRecord::Base
  include Fetchable

  validates :title, presence: true, length: { in: 3..32 },
                    uniqueness: { case_sensitive: false }
  validates :body,  presence: true
  validates :shop,  presence: true

  belongs_to :shop

end
