require 'rails_helper'

RSpec.describe Api::V1::DistributionsController, type: :controller do
  let(:admin) { create :admin }

  before(:each) do
    auth_request admin
  end

  describe 'GET #index' do
    before(:each) do
      5.times { create :distribution }
      get :index, page: 1, sort: 'title asc'
    end

    it 'returns 5 distributions records from the database' do
      response = json_response
      expect(response[:distributions]).to have(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end


  describe 'GET #show' do
    before(:each) do
      @distribution = create :distribution
      get :show, id: @distribution.id
    end

    it 'returns the information about a distribution on a hash' do
      response = json_response[:distribution]
      expect(response[:title]).to eql @distribution.title
    end

    it { should respond_with 200 }
  end


  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        shop = create :shop
        @distribution_attr = attributes_for :distribution, body: 'Body', shop_id: shop.id
        post :create, { distribution: @distribution_attr }
      end

      it 'renders the json representation for the product record just created' do
        response = json_response[:distribution]
        expect(response[:title]).to eql @distribution_attr[:title]
        expect(response[:body]).to  eql @distribution_attr[:body]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        shop = create :shop
        @invalid_distribution_attr = attributes_for :distribution, title: '', shop_id: shop.id
        post :create, { distribution: @distribution_attr }
      end

      it 'renders the json errors on whye the user could not be created' do
        response = json_response
        expect(response).to have_key(:errors)
        expect(response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

  end


  describe 'PUT/PATCH #update' do
    before(:each) do
      @distribution = create :distribution
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { id: @distribution.id, distribution: { title: 'Distribution Super'} }
      end

      it 'renders the json representation for the updated distribution' do
        response = json_response[:distribution]
        expect(response[:title]).to eql 'Distribution Super'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { id: @distribution.id, distribution: { shop_id: nil } }
      end

      it 'renders the json errors on why the product could not be updated' do
        response = json_response
        expect(response).to have_key(:errors)
        expect(response[:errors][:shop]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end


  describe 'DELETE #destroy' do

    context 'when is successfully destroy' do
      before(:each) do
        distribution = create :distribution
        delete :destroy, { id: distribution.id }
      end

      it { should respond_with 204 }
    end

    context 'when distribution is not found' do
      before(:each) do
        delete :destroy, { id: 0 }
      end

      it_behaves_like 'data does not exist'
    end

  end

end
