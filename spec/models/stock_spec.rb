require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:stock) { build(:stock) }

  subject { stock }

  it { should be_valid }

  it { should have_many(:products) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:percent) }

  it { should validate_uniqueness_of(:title) }

  it { should validate_numericality_of(:percent)
                  .only_integer.is_greater_than(0).is_less_than(100) }

end
