class Api::V1::ImagesController < ApplicationController
  respond_to :json
  before_action :authenticate_api_user!, only: [:create, :destroy]
  before_action :set_image, only: [:show, :destroy]


  def index
    respond_with Image.all
  end


  def show
    render json: @image
  end


  def create
    @image = Image.new(image_params)
    if @image.save
      render json: @image, status: 201, location: [:api, @image]
    else
      render json: { errors: @image.errors }, status: 422
    end
  end

  def destroy
    @image.destroy
    head 204
  end

  private

    def image_params
      params.fetch(:image, {}).permit(:file, :imageable_type, :imageable_id)
    end

    def set_image
      @image = Image.find(params[:id])
    end

end
