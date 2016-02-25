require 'rails_helper'

describe User do
  let(:user) { build(:user) }
  let(:manager) { build(:user, :manager) }

  subject { user }

  it { should be_valid }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:role) }
  it { should respond_to(:name) }
  it { should respond_to(:phone) }
  it { should respond_to(:country) }
  it { should respond_to(:city) }
  it { should respond_to(:address) }
  it { should respond_to(:birthday) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:role) }

  it { should validate_inclusion_of(:role).in_array(User::ROLES) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should validate_confirmation_of(:password) }

  it { should allow_value('example@domain.com').for(:email) }

  it { should_not be_manager }

  it { should have_many(:orders) }
  it { should have_many(:favourites) }
  it { should have_many(:favourite_products) }

  context 'manager role' do
    subject { manager }

    it { should be_manager }

  end

end
