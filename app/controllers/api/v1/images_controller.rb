class Api::V1::ImagesController < ApplicationController


  def create
    @image = Image.new(image_params)
    if @image.save
      render json: @image, status: 201, location: [:api, @image]
    else
      render json: { errors: @image.errors }, status: 422
    end
  end

  private

    def image_params
      params.fetch(:image, {}).permit(:file, :imageable_type, :imageable_id)
    end



end
