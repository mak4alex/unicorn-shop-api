require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:manager) { create :user, :manager }

  describe 'GET #index' do

    context 'when unauthorised' do
      before(:each) do
        get :index
      end

      it 'renders errors json with description' do
        order_response = json_response
        expect(order_response).to have_key(:errors)
        expect(order_response[:errors]).to include 'Authorized users only.'
      end

      it { should respond_with 401 }
    end

    context 'when authorised as manager' do
      before(:each) do
        auth_request manager
        5.times { create :order }
        get :index
      end

      it 'returns 5 order records' do
        orders_response = json_response[:orders]
        expect(orders_response).to have_exactly(5).items
      end

      it_behaves_like 'paginated list'

      it { should respond_with 200 }

    end

    context 'when authorised as customer' do
      before(:each) do
        @alice = create :user
        5.times { create :order, user: @alice }
        @bob = create :user
        3.times { create :order, user: @bob }
        auth_request @alice
        get :index
      end

      it 'returns only customer own order records' do
        orders_response = json_response[:orders]
        expect(orders_response).to have_exactly(5).items
        orders_response.each { |order| expect(order[:user_id]).to eq @alice.id }
      end

      it { should respond_with 200 }

    end

  end

  describe 'GET #show' do

    context 'when authorised as manager' do
      before(:each) do
        auth_request manager
        @order = create :order
        get :show, id: @order.id
      end

      it 'returns any order record matching the id' do
        order_response = json_response[:order]
        expect(order_response[:id]).to eql @order.id
      end

      it { should respond_with 200 }

    end

    context 'when authorised as customer' do
      before(:each) do
        @alice = create :user
        @alice_order = create :order, user: @alice
        @bob = create :user
        @bob_order = create :order, user: @bob
        auth_request @alice
      end

      context 'and try to access own order' do
        before(:each) do
          get :show, id: @alice_order.id
        end

        it 'returns order description matching the id' do
          order_response = json_response[:order]
          expect(order_response[:id]).to eql @alice_order.id
        end

        it { should respond_with 200 }
      end

      context "and try to access another's order" do
        before(:each) do
          get :show, id: @bob_order.id
        end

        it 'renders the json errors on why the order could not be showed' do
          order_response = json_response
          expect(order_response[:errors]).to include 'Error 403 Access Denied/Forbidden.'
        end

        it { should respond_with 403 }

      end

    end

  end

  describe 'POST #create' do
    before(:each) do
      @customer = create :user
      auth_request @customer

      @product_1 = create :product, price: 100
      @product_2 = create :product, price: 200

      @line_item_1 = attributes_for :line_item, product_id: @product_1.id, quantity: 2
      @line_item_2 = attributes_for :line_item, product_id: @product_2.id, quantity: 5

    end

    context 'when total is correct' do
      before(:each) do
        order_params = { total: 1200, pay_type: 'cash', line_items: [@line_item_1, @line_item_2] }
        post :create, order: order_params
      end

      it 'returns the just user order record' do
        order_response = json_response[:order]
        expect(order_response[:id]).to be_present
        expect(order_response[:total]).to eql '1200.0'
        expect(order_response[:products]).to have_exactly(2).items
      end

      it { should respond_with 201 }

    end

    context 'when some bitch try to cheat with invalid total' do
      before(:each) do
        order_params = { total: 500, pay_type: 'cash', line_items: [@line_item_1, @line_item_2] }
        post :create, order: order_params
      end

      it 'returns the error why order record not created' do
        order_response = json_response
        expect(order_response[:errors][:total]).to include 'is miscalculated'
      end

      it { should respond_with 422 }
    end

  end

end