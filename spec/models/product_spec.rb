require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build :product }
  subject { product }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:price) }
  it { should respond_to(:quantity) }
  it { should respond_to(:published) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }

  it { should belong_to(:category) }

  it { should_not be_published }

  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:price).is_greater_than(0.0) }

end
