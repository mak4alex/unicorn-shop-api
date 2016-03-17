require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      5.times { create :product_image }
      get :index
    end

    it 'returns 5 product image records from the database' do
      images_response = json_response
      expect(images_response[:images]).to have_at_least(5).items
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before(:each) do
      @image = create :product_image
      get :show, id: @image.id
    end

    it 'returns the information about a image on a hash' do
      image_response = json_response[:image]
      expect(image_response[:image]).to eql @image.file.url
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    before(:each) do
      @user = create :user
      auth_request @user
    end

    context 'when is successfully created' do
      before(:each) do

        @image_attributes = attributes_for :product_image
        post :create, image: @image_attributes
      end

      it 'renders the json representation for the image just created' do
        image_response = json_response[:image]
        expect(image_response[:imageable_id]).to eql @image_attributes[:imageable_id]
        expect(image_response[:image]).to end_with 'product_image.jpg'
        expect(image_response[:thumb]).to end_with 'thumb_product_image.jpg'
      end

      it { should respond_with 201 }

    end

    context 'when is not created' do
      before(:each) do
        @invalid_image_attributes = attributes_for :product_image, imageable_type: 'Fake'
        post :create, image: @invalid_image_attributes
      end

      it 'renders an errors json' do
        image_response = json_response
        expect(image_response).to have_key(:errors)
      end

      it 'renders the json errors on why the image could not be created' do
        image_response = json_response
        expect(image_response[:errors][:imageable_type]).to include "is not included in #{Image::IMAGEABLE_TYPES}"
      end

      it { should respond_with 422 }

    end

  end

  describe 'DELETE #destroy' do

    context 'when user authenticate' do
      before(:each) do
        @user = create :user
        auth_request @user
      end

      context 'when image exists' do
        before(:each) do
          @image = create :product_image
          delete :destroy, { id: @image.id}
        end

        it { should respond_with 204 }
      end

      context 'when image does not exist' do
        before(:each) do
          delete :destroy, { id: 0 }
        end

        it_behaves_like 'data does not exist'
      end

    end

    context 'when user not authenticate' do
      before(:each) do
        @image = create :product_image
        delete :destroy, { id: @image.id }
      end

      it { should respond_with 401 }
    end

  end

end
