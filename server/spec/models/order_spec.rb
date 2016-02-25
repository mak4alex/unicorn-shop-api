require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { build :order }
  subject { order }

  it { should be_valid }

  it { should validate_presence_of(:total) }
  it { should validate_presence_of(:pay_type) }
  it { should validate_presence_of(:delivery_type) }

  it { should respond_to(:status) }
  it { should respond_to(:comment) }

  it { should have_one(:contact) }

  it { should have_many(:line_items) }
  it { should have_many(:products).through(:line_items) }

  it { should validate_numericality_of(:total).is_greater_than(0.0) }

  it { should validate_length_of(:comment).is_at_most(255) }

  it { should validate_inclusion_of(:status).in_array(Order::STATUSES) }
  it { should validate_inclusion_of(:pay_type).in_array(Order::PAY_TYPES) }
  it { should validate_inclusion_of(:delivery_type).in_array(Order::DELIVERY_TYPES) }

end
