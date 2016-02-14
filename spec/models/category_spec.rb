require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { build :category }
  subject { category }

  it { should validate_presence_of :title }
  it { should validate_uniqueness_of(:title).case_insensitive }
  it { should validate_length_of(:title).is_at_least(3).is_at_most(32) }
  it { should validate_presence_of :description }
  it { should validate_length_of(:description).is_at_least(16) }
  it { should have_many(:products) }

end
