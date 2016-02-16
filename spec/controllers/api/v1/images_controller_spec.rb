require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do

  describe 'POST #create' do

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


end
