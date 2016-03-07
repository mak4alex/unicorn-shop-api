require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:line_item) { build :line_item }
  subject { line_item }

  it { should respond_to :order_id }
  it { should respond_to :product_id }

  it { should validate_presence_of :quantity }
  it { should validate_presence_of :order }
  it { should validate_presence_of :product }

  it { should belong_to(:order) }
  it { should belong_to(:product) }

  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(1) }


  it 'should decrease product quantity when created' do
    product = create :product, quantity: 20
    line_item = create :line_item, product: product, quantity: 10
    expect(product.quantity).to eq 10
  end

end
