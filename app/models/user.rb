class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation do
    self.uid = email if uid.blank?
  end

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: Devise::email_regexp

end
