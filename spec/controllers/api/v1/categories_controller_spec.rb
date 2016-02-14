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
    before(:each) do
      @category = create :category
      get :show, id: @category.id
    end

    it 'returns the information about a category' do
      category_response = json_response
      expect(category_response[:title]).to eql @category.title
      expect(category_response[:description]).to eql @category.description
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        @category_attributes = attributes_for :category
        post :create, { category: @category_attributes }
      end

      it 'renders the json representation for the category record just created' do
        category_response = json_response
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


  describe 'PUT/PATCH #update' do
    before(:each) do
      @category = create :category
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { id: @category.id, category: { title: 'New Category' } }
      end

      it 'renders the json representation for the updated category' do
        category_response = json_response
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

  describe 'DELETE #destroy' do
    before(:each) do
      @category = create :category
      delete :destroy, { id: @category.id }
    end

    it { should respond_with 204 }
  end

end
