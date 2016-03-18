require 'rails_helper'

RSpec.describe Api::V1::FavouritesController, type: :controller do

  let (:admin) { create :admin }
  let (:user)  { create :user }

  describe 'GET #index' do

    before(:each) do
      @bob = create :user
      5.times { create :favourite, user: @bob }
      3.times { create :favourite }
    end

    context 'when authorized like user' do
      before(:each) do
        auth_request @bob
        get :index, page: 1, sort: 'product_id'
      end

      it 'returns only users own favourites records' do
        favourites_response = json_response
        expect(favourites_response[:favourites]).to have_exactly(5).items
      end

      it { should respond_with 200 }

      it_behaves_like 'with meta data'

    end

    context 'when authorized like admin' do
      before(:each) do
        auth_request admin
        get :index
      end

      it 'returns all favourites records' do
        favourites_response = json_response
        expect(favourites_response[:favourites]).to have_exactly(8).items
      end

    end

  end


  describe 'POST #create' do

    context 'when authorized like user' do
      before(:each) do
        @product = create :product
        @user = user
        auth_request @user
        post :create, favourite: { product_id: @product.id }
      end

      it 'renders the json representation for the favourite record just created' do
        response = json_response[:favourite]
        expect(response[:user_id]).to eql @user.id
        expect(response[:product_id]).to eql @product.id
      end

      it { should respond_with 201 }

    end

    context 'when not authenticate' do
      before(:each) do
        @product = create :product
        post :create, favourite: { product_id: @product.id }
      end

      it_behaves_like 'not authenticate'

    end

  end


  describe 'DELETE #destroy' do

    context 'when authorized like user' do
      before(:each) do
        @bob = create :user
        @alice = create :user
        @bob_favourite = create :favourite, user: @bob
        @alice_favourite = create :favourite, user: @alice
      end

      context 'when delete own record' do

        it 'should delete favourite' do
          auth_request @bob
          delete :destroy, id: @bob_favourite.id
          should respond_with 204
        end

      end

      context 'when delete other record' do

        before(:each) do
          auth_request @bob
          delete :destroy, id: @alice_favourite.id
        end

        it_behaves_like 'access forbidden'

      end




    end

    context 'when authorized like admin' do

      it 'should delete any record' do
        favourite = create :favourite
        auth_request admin
        delete :destroy, id: favourite.id
        should respond_with 204
      end

    end

  end

end
