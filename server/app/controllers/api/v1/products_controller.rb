class Api::V1::ProductsController < ApplicationController
  respond_to :json
  before_action :authenticate_api_user!, only: [:create, :update, :destroy]
  before_action :manager_only!, only: [:create, :update, :destroy]
  before_action :set_product, only: [:show, :update, :destroy]

  api! 'List all products'
  def index
    products = Product.page(params[:page]).per(params[:per_page])
    render json: products, meta: pagination(products, params[:per_page])
  end

  api! 'Show product with id'
  def show
    render json: @product
  end

  def_param_group :product do
    param :product, Hash, required: true, action_aware: true do
      param :title, String, required: true
      param :description, String, required: true
      param :price, String, required: true
      param :count, String
      param :published, String
      param :category_id, String, required: true
    end
  end

  api! 'Create product'
  param_group :product
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: 201, location: [:api, @product]
    else
      render json: { errors: @product.errors }, status: 422
    end
  end

  api! 'Update product with id'
  param_group :product
  def update
    if @product.update(product_params)
      render json: @product, status: 200, location: [:api, @product]
    else
      render json: { errors: @product.errors }, status: 422
    end
  end

  api! 'Destroy product with id'
  def destroy
    @product.destroy
    head 204
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.fetch(:product, {}).permit( :title, :description, :price,
                                       :quantity, :published, :category_id, :weight)
    end

end
