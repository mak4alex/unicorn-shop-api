require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      5.times { create :category }
      get :index
    end

    it 'returns the information about all categories' do
      category_response = json_response
      expect(category_response[:categories]).to have(5).items
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do

    context 'when category exists' do
      before(:each) do
        @category = create :category
        get :show, id: @category.id
      end

      it 'returns the information about a category' do
        category_response = json_response[:category]
        expect(category_response[:title]).to eql @category.title
        expect(category_response[:description]).to eql @category.description
        expect(category_response).to have_key(:product_ids)
      end

      it { should respond_with 200 }

    end

    context 'when category does not exist' do
      before(:each) do
        get :show, id: 0
      end

      it 'renders the json errors on why the category not showed' do
        category_response = json_response
        expect(category_response[:errors]).to include 'Resource not found.'
      end

      it { should respond_with 404 }

    end

  end

  describe 'POST #create' do

    context 'when user authenticate' do
      before(:each) do
        @user = create :user
        auth_request @user
      end

      context 'when is successfully created' do
        before(:each) do
          @category_attributes = attributes_for :category
          post :create, { category: @category_attributes }
        end

        it 'renders the json representation for the category record just created' do
          category_response = json_response[:category]
          expect(category_response[:title]).to eql @category_attributes[:title]
        end

        it { should respond_with 201 }

      end

      context 'when is not created' do
        before(:each) do
          @invalid_category_attributes = { title: '', description: 'Short desc'}
          post :create, { category: @invalid_category_attributes }
        end

        it 'renders an errors json' do
          category_response = json_response
          expect(category_response).to have_key(:errors)
        end

        it 'renders the json errors on why the category could not be created' do
          category_response = json_response
          expect(category_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }

      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        @category_attributes = attributes_for :category
        post :create, { category: @category_attributes }
      end

      it 'renders the json errors on why the category could not be created' do
        category_response = json_response
        expect(category_response[:errors]).to include 'Authorized users only.'
      end

      it { should respond_with 401 }

    end

  end


  describe 'PUT/PATCH #update' do
    before(:each) do
      @category = create :category
    end

    context 'when user authenticate' do
      before(:each) do
        @user = create :user
        auth_request @user
      end

      context 'when is successfully updated' do
        before(:each) do
          patch :update, { id: @category.id, category: { title: 'New Category' } }
        end

        it 'renders the json representation for the updated category' do
          category_response = json_response[:category]
          expect(category_response[:title]).to eql 'New Category'
        end

        it { should respond_with 200 }

      end

      context 'when is not updated' do
        before(:each) do
          patch :update, { id: @category.id, category: { title: '' } }
        end

        it 'renders an errors json' do
          category_response = json_response
          expect(category_response).to have_key(:errors)
        end

        it 'renders the json errors on why the category could not be created' do
          category_response = json_response
          expect(category_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }

      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        patch :update, { id: @category.id, category: { title: 'New Category' } }
      end

      it 'renders the json errors on why the category could not be updated' do
        category_response = json_response
        expect(category_response[:errors]).to include 'Authorized users only.'
      end

      it { should respond_with 401 }

    end

  end

  describe 'DELETE #destroy' do

    context 'when user authenticate' do
      before(:each) do
        @user = create :user
        auth_request @user
      end

      context 'when category exists' do
        before(:each) do
          @category = create :category
          delete :destroy, { id: @category.id }
        end

        it { should respond_with 204 }

      end

      context 'when category does not exist' do
        before(:each) do
          delete :destroy, { id: 0 }
        end

        it 'renders the json errors on why the category could not be destroyed' do
          category_response = json_response
          expect(category_response[:errors]).to include 'Resource not found.'
        end

        it { should respond_with 404 }

      end

    end

    context 'when user not authenticate' do
      before(:each) do
        @category = create :category
        delete :destroy, { id: @category.id }
      end

      it 'renders the json errors on why the category could not be destroyed' do
        category_response = json_response
        expect(category_response[:errors]).to include 'Authorized users only.'
      end

      it { should respond_with 401 }

    end

  end

end
