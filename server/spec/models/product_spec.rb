require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build :product }
  subject { product }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:price) }
  it { should respond_to(:quantity) }
  it { should respond_to(:weight) }
  it { should respond_to(:published) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:weight) }
  it { should validate_presence_of(:category_id) }

  it { should belong_to(:category) }

  it { should have_many(:images) }
  it { should have_many(:line_items) }
  it { should have_many(:orders).through(:line_items) }
  it { should have_many(:favourites) }
  it { should have_many(:fans).through(:favourites)  }

  it { should_not be_published }

  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:price).is_greater_than(0.0) }

  describe 'product filtering and search' do
    before(:each) do
      @product1 = create :product, title: 'Computer', price: 100, quantity: 10, weight: 100
      @product2 = create :product, price: 50, quantity: 0, weight: 150
      @product3 = create :product, price: 150, quantity: 15, weight: 50
      @product4 = create :product, title: 'AxeComputer', price: 99, quantity: 5, weight: 20
      @product5 = create :product, price: 120, quantity: 30, weight: 70
    end

    context 'when filter by title' do
      it 'returns the products which are match title' do
        products = Product.filter_by_title('Compu')
        expect(products).to match_array([@product1, @product4])
      end
    end

    context 'when filter by price' do
      it 'returns the products which are below or eq and above or eq to the price' do
        products = Product.below_or_equal_to_price(120).above_or_equal_to_price(100)
        expect(products.sort(sort: 'price desc')).to match_array([@product5, @product1])
      end
    end

    context 'when filter by quantity' do
      it 'returns the products which are below or eq and above or eq to the quantity' do
        products = Product.below_or_equal_to_quantity(15).above_or_equal_to_quantity(10)
        expect(products.sort(sort: 'quantity desc')).to match_array([@product3, @product1])
      end
    end

    context 'when search by title and price' do
      it 'returns the products which are math search query' do
        params = { max_price: 100, title: 'Comp', min_quantity: 7 }
        products = Product.search(params)
        expect(products).to match_array([@product1])
      end
    end

  end

end
