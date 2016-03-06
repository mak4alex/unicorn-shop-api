require 'rails_helper'

RSpec.describe Distribution, type: :model do
  let(:distribution) { build :distribution }
  subject { distribution }

  it { should be_valid }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should validate_uniqueness_of(:title).case_insensitive }

  it { should validate_length_of(:title).is_at_least(3).is_at_most(32) }

  it { should belong_to(:shop) }
end
