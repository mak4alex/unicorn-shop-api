require 'rails_helper'

RSpec.describe Shop, type: :model do
  let(:shop) { build :shop }
  subject { shop }

  it { should be_valid }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:register_number) }

  it { should validate_uniqueness_of(:title).case_insensitive }
  it { should validate_uniqueness_of(:register_number).case_insensitive }


  it { should validate_length_of(:register_number).is_at_least(8).is_at_most(32) }

  it { should have_many(:discounts) }
  it { should have_many(:distributions) }
  it { should have_many(:categories) }

end
