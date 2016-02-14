require 'rails_helper'

describe Api::V1::UsersController do

  describe 'GET #index' do
    before(:each) do
      5.times { create :user }
      get :index
    end

    it 'returns the information about all users' do
      category_response = json_response
      expect(category_response[:users]).to have(5).items
    end

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

      it 'returns the errors' do
        user_response = json_response
        expect(user_response[:errors]).to include('Resource not found.')
      end

      it { is_expected.to respond_with 404 }
    end

  end

  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        @user_attributes = attributes_for :user
        post :create, { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        #notice I'm not including the email
        @invalid_user_attributes = { password: '12345678',
                                     password_confirmation: '12345678'}
        post :create, { user: @invalid_user_attributes }
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
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
    before(:each) do
      @user = create :user
      delete :destroy, { id: @user.id }
    end

    it { is_expected.to respond_with 204 }

  end

end
