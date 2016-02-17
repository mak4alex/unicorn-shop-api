require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe 'GET #index' do
    let(:manager) { create :user, :manager }


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

end
