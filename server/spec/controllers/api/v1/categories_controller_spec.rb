require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      5.times { create :category }
      get :index, sort: 'title desc', page: 1
    end

    it 'returns the information about all categories' do
      category_response = json_response
      expect(category_response[:categories]).to have(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end


  describe 'GET #count' do
    before(:each) do
      @category = create :category_with_subcategories, count: 5
      get :count
    end

    it 'returns count of categories' do
      count = json_response[:count]
      expect(count).to eq 6
    end

    it { should respond_with 200 }
  end

  describe 'GET #products' do
    before(:each) do
      category = create :category_with_products, count: 5
      get :products, id: category.id, sort: 'title desc', page: 1
    end

    it 'returns products from category' do
      products_response = json_response[:products]
      expect(products_response).to have_exactly(5).items
    end

    it_behaves_like 'with meta data'

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
        expect(category_response).to have_key(:parent_category_id)
        expect(category_response).to have_key(:subcategory_ids)
      end

      it { should respond_with 200 }

    end

    context 'when category does not exist' do
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

        it 'renders the json errors on why the category could not be created' do
          category_response = json_response
          expect(category_response).to have_key(:errors)
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

      it_behaves_like 'not authenticate'
    end

  end


  describe 'PUT/PATCH #update' do
    before(:each) do
      @category = create :category
    end

    context 'when user authenticate' do
      before(:each) do
        @manager = create :user, :manager
        auth_request @manager
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

        it 'renders the json errors on why the category could not be created' do
          category_response = json_response
          expect(category_response).to have_key(:errors)
          expect(category_response[:errors][:title]).to include "can't be blank"
        end

        it { should respond_with 422 }

      end

    end

    context 'when user does not authenticate' do
      before(:each) do
        patch :update, { id: @category.id, category: { title: 'New Category' } }
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
          @category = create :category
          delete :destroy, { id: @category.id }
        end

        it_behaves_like 'access forbidden'

      end

      context 'as manager' do
        before(:each) do
          @manager = create :user, :manager
          auth_request @manager
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

          it_behaves_like 'data does not exist'

        end

      end

    end

    context 'when user not authenticate' do
      before(:each) do
        @category = create :category
        delete :destroy, { id: @category.id }
      end

      it_behaves_like 'not authenticate'

    end

  end

end
