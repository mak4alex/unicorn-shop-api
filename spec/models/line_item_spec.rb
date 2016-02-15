require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:line_item) { build :line_item }
  subject { line_item }

  it { should validate_presence_of :quantity }
  it { should validate_presence_of :product }
  it { should validate_presence_of :order }

  it { should belong_to(:order) }
  it { should belong_to(:product) }

  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(1) }

end
