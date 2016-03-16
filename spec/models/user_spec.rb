require 'rails_helper'

describe User do
  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:phone) }
  it { should respond_to(:country) }
  it { should respond_to(:city) }
  it { should respond_to(:address) }
  it { should respond_to(:birthday) }

  it { should validate_presence_of(:email) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should validate_confirmation_of(:password) }

  it { should validate_inclusion_of(:sex).in_array(User::SEXES) }

  it { should have_many(:orders) }
  it { should have_many(:favourites) }
  it { should have_many(:favourite_products) }

end
