require 'rails_helper'

RSpec.describe Discount, type: :model do
  let(:discount) { build(:discount) }

  subject { discount }

  it { should be_valid }

  it { should belong_to(:shop) }

  it { should validate_presence_of(:initial_sum) }
  it { should validate_presence_of(:percent) }
  it { should validate_presence_of(:shop) }

  it { should validate_uniqueness_of(:initial_sum) }

  it { should validate_numericality_of(:percent)
                  .is_greater_than(0.0).is_less_than(100.0) }
end
