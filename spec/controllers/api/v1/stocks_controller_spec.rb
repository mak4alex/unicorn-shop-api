require 'rails_helper'

RSpec.describe Api::V1::StocksController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      5.times { create :stock }
      get :index, sort: 'title desc', page: 1
    end

    it 'returns the information about all stocks' do
      stock_response = json_response
      expect(stock_response[:stocks]).to have(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end


  describe 'GET #count' do
    before(:each) do
      5.times { create :stock }
      get :count
    end

    it 'returns count of stocks' do
      count = json_response[:count]
      expect(count).to eq 5
    end

    it { should respond_with 200 }
  end

  describe 'GET #products' do
    before(:each) do
      stock = create :stock_with_products, count: 5
      get :products, id: stock.id, sort: 'title desc', page: 1
    end

    it 'returns products on stock' do
      products_response = json_response[:products]
      expect(products_response).to have_exactly(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end

  describe 'GET #show' do

    context 'when stock exists' do
      before(:each) do
        @stock = create :stock
        get :show, id: @stock.id
      end

      it 'returns the information about a stock' do
        stock_response = json_response[:stock]
        expect(stock_response[:title]).to eql @stock.title
        expect(stock_response[:percent]).to eql @stock.percent
        expect(stock_response).to have_key(:product_ids)
      end

      it { should respond_with 200 }

    end

    context 'when stock does not exist' do
      before(:each) do
        get :show, id: 0
      end

      it_behaves_like 'data does not exist'
    end

  end


  describe 'POST #create' do

    context 'when user authenticate' do
      before(:each) do
        @admin = create :admin
        auth_request @admin
      end

      context 'when is successfully created' do
        before(:each) do
          @stock_attributes = attributes_for :stock
          post :create, { stock: @stock_attributes }
        end

        it 'renders the json representation for the stock record just created' do
          stock_response = json_response[:stock]
          expect(stock_response[:title]).to eql @stock_attributes[:title]
        end

        it { should respond_with 201 }
      end

      context 'when is not created' do
        before(:each) do
          @invalid_stock_attributes = { title: '', percent: 3 }
          post :create, { stock: @invalid_stock_attributes }
        end

        it 'renders the json errors on why the stock could not be created' do
          stock_response = json_response
          expect(stock_response).to have_key(:errors)
          expect(stock_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }
      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        @stock_attributes = attributes_for :stock
        post :create, { stock: @stock_attributes }
      end

      it_behaves_like 'not authenticate'
    end

  end


  describe 'PUT/PATCH #update' do
    before(:each) do
      @stock = create :stock
    end

    context 'when user authenticate' do
      before(:each) do
        @admin = create :admin
        auth_request @admin
      end

      context 'when is successfully updated' do
        before(:each) do
          patch :update, { id: @stock.id, stock: { title: 'New stock' } }
        end

        it 'renders the json representation for the updated stock' do
          stock_response = json_response[:stock]
          expect(stock_response[:title]).to eql 'New stock'
        end

        it { should respond_with 200 }

      end

      context 'when is not updated' do
        before(:each) do
          patch :update, { id: @stock.id, stock: { title: '' } }
        end

        it 'renders the json errors on why the stock could not be created' do
          stock_response = json_response
          expect(stock_response).to have_key(:errors)
          expect(stock_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }

      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        patch :update, { id: @stock.id, stock: { title: 'New stock' } }
      end

      it_behaves_like 'not authenticate'

    end

  end

  describe 'DELETE #destroy' do

    context 'when user authenticate' do

      context 'as customer' do
        before(:each) do
          @customer = create :user
          auth_request @customer
          @stock = create :stock
          delete :destroy, { id: @stock.id }
        end

        it_behaves_like 'not authenticate'

      end

      context 'as admin' do
        before(:each) do
          @admin = create :admin
          auth_request @admin
        end

        context 'when stock exists' do
          before(:each) do
            @stock = create :stock
            delete :destroy, { id: @stock.id }
          end

          it { should respond_with 204 }

        end

        context 'when stock does not exist' do
          before(:each) do
            delete :destroy, { id: 0 }
          end

          it_behaves_like 'data does not exist'

        end

      end

    end

    context 'when user not authenticate' do
      before(:each) do
        @stock = create :stock
        delete :destroy, { id: @stock.id }
      end

      it_behaves_like 'not authenticate'

    end

  end

end
