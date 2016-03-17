require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :controller do
  let(:admin) { create :admin }
  let(:user) { create :user }
  let(:product) { create :product }


  describe 'GET #index' do
    before(:each) do
      5.times { create :review }
      get :index, page: 1, sort: 'rating desc'
    end

    it 'returns 5 order records' do
      expect(json_response[:reviews]).to have_exactly(5).items
    end

    it_behaves_like 'with meta data'

    it { should respond_with 200 }
  end


  describe 'GET #show' do
    before(:each) do
      @review = create :review
      get :show, id: @review.id
    end

    it 'returns review record matching the id' do
      review_response = json_response[:review]
      expect(review_response[:id]).to eql @review.id
      expect(review_response[:user_id]).to eql @review.user_id
      expect(review_response[:product_id]).to eql @review.product_id
      expect(review_response[:rating]).to eql @review.rating
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    before(:each) do
      @customer = create :user
      @product = create :product
      @review_attr = attributes_for :review, product_id: @product.id
      auth_request @customer
      post :create, review: @review_attr
    end

    context 'when review is successfully created ' do
      it 'returns the review record' do
        review_response = json_response[:review]
        expect(review_response[:id]).to be_present
        expect(review_response[:rating]).to eql @review_attr[:rating]
        expect(review_response[:user_id]).to eql @customer.id
        expect(review_response[:product_id]).to eql @review_attr[:product_id]
        expect(review_response[:body]).to eql @review_attr[:body]
      end

      it { should respond_with 201 }
    end

  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      bob = user
      auth_request bob
      @review = create :review, user_id: bob.id
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { id: @review.id, review: { body: 'Good product', rating: 5 } }
      end

      it 'renders the json representation for the updated review' do
        review_response = json_response[:review]
        expect(review_response[:body]).to eql 'Good product'
        expect(review_response[:rating]).to eql 5
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { id: @review.id, review: { rating: 20} }
      end

      it 'renders the json errors on why the review could not be updated' do
        expect(json_response[:errors][:rating]).to include 'must be less than or equal to 10'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do

    context 'when authorized as review owner' do
      before(:each) do
        @bob = user
        auth_request @bob
        review = create :review, user: @bob
        delete :destroy, { id: review.id }
      end

      it { should respond_with 204 }
    end

    context 'when authorized as admin' do
      before(:each) do
        auth_request admin
        review = create :review
        delete :destroy, { id: review.id }
      end

      it { should respond_with 204 }
    end

    context 'when authorized as other user' do
      before(:each) do
        auth_request user
        review = create :review
        delete :destroy, { id: review.id }
      end

      it_behaves_like 'access forbidden'
    end

  end

end
