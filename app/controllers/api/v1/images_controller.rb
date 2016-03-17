class Api::V1::ImagesController < ApplicationController
  before_action :set_image,            only: [:show, :destroy]
  before_action :authenticate_member!, only: [:create, :destroy]
  before_action :check_member!,        only: [:create, :destroy]

  api!
  def index
    images = Image.fetch(params)
    render json: { images: images, meta: get_meta(images, params) }
  end

  api!
  def show
    render json: @image
  end

  api!
  def create
    @image = Image.new(image_params)
    if @image.save
      render json: @image, status: 201, location: [:api, @image]
    else
      render json: { errors: @image.errors }, status: 422
    end
  end

  api!
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
