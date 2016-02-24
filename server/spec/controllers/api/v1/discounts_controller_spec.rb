require 'rails_helper'

RSpec.describe Api::V1::DiscountsController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      5.times { create :discount }
      get :index, sort: 'title desc', page: 1
    end

    it 'returns the information about all discounts' do
      discount_response = json_response
      expect(discount_response[:discounts]).to have(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end


  describe 'GET #count' do
    before(:each) do
      5.times { create :discount }
      get :count
    end

    it 'returns count of discounts' do
      count = json_response[:count]
      expect(count).to eq 5
    end

    it { should respond_with 200 }
  end

  describe 'GET #products' do
    before(:each) do
      discount = create :discount_with_products, count: 5
      get :products, id: discount.id, sort: 'title desc', page: 1
    end

    it 'returns products on discount' do
      products_response = json_response[:products]
      expect(products_response).to have_exactly(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end

  describe 'GET #show' do

    context 'when discount exists' do
      before(:each) do
        @discount = create :discount
        get :show, id: @discount.id
      end

      it 'returns the information about a discount' do
        discount_response = json_response[:discount]
        expect(discount_response[:title]).to eql @discount.title
        expect(discount_response[:percent]).to eql @discount.percent
        expect(discount_response).to have_key(:product_ids)
      end

      it { should respond_with 200 }

    end

    context 'when discount does not exist' do
      before(:each) do
        get :show, id: 0
      end

      it_behaves_like 'data does not exist'
    end

  end


  describe 'POST #create' do

    context 'when user authenticate' do
      before(:each) do
        @manager = create :user, :manager
        auth_request @manager
      end

      context 'when is successfully created' do
        before(:each) do
          @discount_attributes = attributes_for :discount
          post :create, { discount: @discount_attributes }
        end

        it 'renders the json representation for the discount record just created' do
          discount_response = json_response[:discount]
          expect(discount_response[:title]).to eql @discount_attributes[:title]
        end

        it { should respond_with 201 }
      end

      context 'when is not created' do
        before(:each) do
          @invalid_discount_attributes = { title: '', percent: 3 }
          post :create, { discount: @invalid_discount_attributes }
        end

        it 'renders the json errors on why the discount could not be created' do
          discount_response = json_response
          expect(discount_response).to have_key(:errors)
          expect(discount_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }
      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        @discount_attributes = attributes_for :discount
        post :create, { discount: @discount_attributes }
      end

      it_behaves_like 'not authenticate'
    end

  end


  describe 'PUT/PATCH #update' do
    before(:each) do
      @discount = create :discount
    end

    context 'when user authenticate' do
      before(:each) do
        @manager = create :user, :manager
        auth_request @manager
      end

      context 'when is successfully updated' do
        before(:each) do
          patch :update, { id: @discount.id, discount: { title: 'New discount' } }
        end

        it 'renders the json representation for the updated discount' do
          discount_response = json_response[:discount]
          expect(discount_response[:title]).to eql 'New discount'
        end

        it { should respond_with 200 }

      end

      context 'when is not updated' do
        before(:each) do
          patch :update, { id: @discount.id, discount: { title: '' } }
        end

        it 'renders the json errors on why the discount could not be created' do
          discount_response = json_response
          expect(discount_response).to have_key(:errors)
          expect(discount_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }

      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        patch :update, { id: @discount.id, discount: { title: 'New discount' } }
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
          @discount = create :discount
          delete :destroy, { id: @discount.id }
        end

        it_behaves_like 'access forbidden'

      end

      context 'as manager' do
        before(:each) do
          @manager = create :user, :manager
          auth_request @manager
        end

        context 'when discount exists' do
          before(:each) do
            @discount = create :discount
            delete :destroy, { id: @discount.id }
          end

          it { should respond_with 204 }

        end

        context 'when discount does not exist' do
          before(:each) do
            delete :destroy, { id: 0 }
          end

          it_behaves_like 'data does not exist'

        end

      end

    end

    context 'when user not authenticate' do
      before(:each) do
        @discount = create :discount
        delete :destroy, { id: @discount.id }
      end

      it_behaves_like 'not authenticate'

    end

  end

end
