require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:admin) { create :admin }

  describe 'GET #index' do

    context 'when unauthorised' do
      before(:each) do
        get :index
      end

      it_behaves_like 'not authenticate'
    end

    context 'when authorised as admin' do
      it 'returns 5 order records' do
        auth_request admin
        5.times { create :order }
        get :index

        should respond_with 200
        orders_response = json_response[:orders]
        expect(orders_response).to have_exactly(5).items
      end
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
        should respond_with 200
        orders_response = json_response[:orders]
        expect(orders_response).to have_exactly(5).items
        orders_response.each { |order| expect(order[:user_id]).to eq @alice.id }
      end
    end

  end

  describe 'GET #show' do

    context 'when authorised as admin' do
      before(:each) do
        auth_request admin
        @order = create :order
        get :show, id: @order.id
      end

      it 'returns any order record matching the id' do
        should respond_with 200
        order_response = json_response[:order]
        expect(order_response[:id]).to eql @order.id
      end
    end

    context 'when authorised as customer' do
      before(:each) do
        @alice = create :user
        @alice_order = create :order, user: @alice
        @bob = create :user
        @bob_order = create :order, user: @bob
        auth_request @alice
      end

      it 'returns order description for own order' do
        get :show, id: @alice_order.id
        should respond_with 200
        order_response = json_response[:order]
        expect(order_response[:id]).to eql @alice_order.id
      end

      context "and try to access another's order" do
        before(:each) do
          get :show, id: @bob_order.id
        end

        it_behaves_like 'access forbidden'
      end

    end

  end

  describe 'POST #create' do
    before(:each) do
      @product_1 = create :product, price: 100
      @product_2 = create :product, price: 200
      @contact = attributes_for :contact
      @line_item_1 = attributes_for :line_item, product_id: @product_1.id, quantity: 2
      @line_item_2 = attributes_for :line_item, product_id: @product_2.id, quantity: 5
    end

    context 'when unauthorised' do
      it 'returns the created order when request data is correct' do
        order_params = { total: 1200.0, pay_type: 'cash', delivery_type: 'mail',
                         contact: @contact, line_items: [@line_item_1, @line_item_2] }
        post :create, order: order_params

        should respond_with 201
        order_response = json_response[:order]
        expect(order_response[:id]).to be_present
        expect(order_response[:total]).to eql '1200.0'
        expect(order_response[:products]).to have_exactly(2).items
        expect(order_response).to have_key(:contact)
        expect(order_response[:contact][:order_id]).to eql order_response[:id]
        expect(order_response[:contact][:email]).to eql @contact[:email]
      end
    end

    context 'when authorised as customer' do
      before(:each) do
        @customer = create :user
        auth_request @customer
      end


      it 'returns the just user order record when request data is correct' do
        order_params = { total: 1200.0, pay_type: 'cash', delivery_type: 'mail',
                         contact: @contact, line_items: [@line_item_1, @line_item_2] }
        post :create, order: order_params

        should respond_with 201
        order_response = json_response[:order]
        expect(order_response[:id]).to be_present
        expect(order_response[:total]).to eql '1200.0'
        expect(order_response[:products]).to have_exactly(2).items
        expect(order_response).to have_key(:contact)
        expect(order_response[:contact][:order_id]).to eql order_response[:id]
        expect(order_response[:contact][:email]).to eql @contact[:email]
      end

      it 'returns the error why order record not created when contact is incorrect' do
        @contact[:email] = nil
        order_params = { total: 1200, pay_type: 'cash', delivery_type: 'mail',
                         contact: @contact, line_items: [@line_item_1, @line_item_2] }
        post :create, order: order_params

        should respond_with 422
        expect(json_response[:errors][:contact]).to include 'is invalid'
      end

      it 'returns the error when total is invalid' do
        order_params = { total: 500, pay_type: 'cash', line_items: [@line_item_1, @line_item_2] }
        post :create, order: order_params

        should respond_with 422
        order_response = json_response
        expect(order_response[:errors][:total]).to include 'is miscalculated'
      end

    end

  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      auth_request admin
      @order = create :order
    end

    it 'update order and renders the json representation for the updated order' do
      patch :update, { id: @order.id, order: { status: 'done' } }

      should respond_with 200
      product_response = json_response[:order]
      expect(product_response[:status]).to eql 'done'
    end

    it 'renders the json errors on why the order could not be updated' do
      patch :update, { id: @order.id, order: { status: 'ololo'} }

      should respond_with 422
      response = json_response
      expect(response).to have_key(:errors)
      expect(response[:errors][:status]).to include 'is not included in the list'
    end

  end

  describe 'DELETE #destroy' do

    it 'should successfully destroy when authorized as admin' do
      auth_request admin
      order = create :order
      delete :destroy, { id: order.id }
      should respond_with 204
    end

  end

end
