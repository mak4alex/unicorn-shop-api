require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { build(:contact) }

  subject { contact }

  it { should be_valid }

  it { should belong_to(:order) }

  it { should validate_presence_of(:order) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:address) }

  it { should respond_to(:comment) }

end
