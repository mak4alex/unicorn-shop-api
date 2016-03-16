require 'rails_helper'

describe Admin do
  let(:admin) { build(:admin) }

  subject { admin }

  it { should be_valid }

  it { should validate_presence_of(:email) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should validate_confirmation_of(:password) }

end
