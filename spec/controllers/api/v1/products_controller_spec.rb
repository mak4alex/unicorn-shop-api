require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      5.times { create :product }
      get :index
    end

    it 'returns 5 product records from the database' do
      products_response = json_response
      expect(products_response[:products]).to have(5).items
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before(:each) do
      @product = create :product
      get :show, id: @product.id
    end

    it 'returns the information about a reporter on a hash' do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do

    context 'when user authenticated' do

      context 'as customer' do

        before(:each) do
          @customer = create :user
          auth_request @customer
          @product_attributes = attributes_for :product, category_id: 1, published: ''
          post :create, { product: @product_attributes }
        end

        it 'renders the json errors on why the product could not be created' do
          product_response = json_response
          expect(product_response[:errors]).to include 'Error 403 Access Denied/Forbidden.'
        end

        it { should respond_with 403 }

      end

      context 'as manager' do
        before(:each) do
          auth_request create(:manager)
        end

        context 'when is successfully created' do
          before(:each) do
            @product_attributes = attributes_for :product, category_id: 1, published: ''
            post :create, { product: @product_attributes }
          end

          it 'renders the json representation for the product record just created' do
            product_response = json_response
            expect(product_response[:title]).to eql @product_attributes[:title]
          end

          it { should respond_with 201 }
        end

        context 'when is not created' do
          before(:each) do
            @invalid_product_attributes = attributes_for :product, quantity: 'Twelve dollars',
                                                         category_id: 1, published: ''
            post :create, { product: @invalid_product_attributes }
          end

          it 'renders an errors json' do
            product_response = json_response
            expect(product_response).to have_key(:errors)
          end

          it 'renders the json errors on whye the user could not be created' do
            product_response = json_response
            expect(product_response[:errors][:quantity]).to include 'is not a number'
          end

          it { should respond_with 422 }
        end

      end

    end

  end


  describe 'PUT/PATCH #update' do
    before(:each) do
      auth_request create(:manager)
      @product = create :product
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { id: @product.id, product: { title: "An expensive TV" } }
      end

      it 'renders the json representation for the updated user' do
        product_response = json_response
        expect(product_response[:title]).to eql "An expensive TV"
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { id: @product.id, product: { price: 'two hundred'} }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the product could not be updated' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do

    context 'when is successfully destroy' do
      before(:each) do
        auth_request create(:manager)
        @product = create :product
        delete :destroy, { id: @product.id }
      end

      it { should respond_with 204 }

    end

    context 'when is product not found' do
      before(:each) do
        auth_request create(:manager)
        delete :destroy, { id: 0 }
      end

      it 'renders the json errors on why the product could not be destroyed' do
        product_response = json_response
        expect(product_response[:errors]).to include 'Resource not found.'
      end

      it { should respond_with 404 }

    end

  end

end
