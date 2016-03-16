require 'rails_helper'

describe Api::V1::UsersController do

  before(:each) do
    @admin = create :admin
    auth_request @admin
  end

  describe 'GET #index' do
    before(:each) do
      5.times { create :user }
      get :index, sort: 'email desc', page: 1
    end

    it 'returns the information about all users' do
      user_response = json_response
      expect(user_response[:users]).to have(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end

  describe 'GET #show' do

    context 'when user exists' do
      before(:each) do
        @user = create :user
        get :show, id: @user.id
      end

      it 'returns the information about a user on a hash' do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql @user.email
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when user does not exist' do
      before(:each) do
        get :show, id: 'not_exists'
      end

      it_behaves_like 'data does not exist'
    end

  end


  describe 'PUT/PATCH #update' do

    context 'when is successfully updated' do
      before(:each) do
        @user = create :user
        patch :update, { id: @user.id,
                         user: { email: 'newmail@example.com'} }
      end

      it 'renders the json representation for the updated user' do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql 'newmail@example.com'
      end

      it { is_expected.to respond_with 200 }
    end

    context "when is not created" do
      before(:each) do
        @user = create :user
        patch :update, { id: @user.id,
                         user: { email: "bademail.com" } }
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        user_response = json_response
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it { is_expected.to respond_with 422 }
    end

  end

  describe 'DELETE #destroy' do

    context 'when authenticate as admin' do

      context 'when category exists' do
        before(:each) do
          @user = create :user
          delete :destroy, { id: @user.id }
        end

        it { should respond_with 204 }
      end

    end
  end

end
