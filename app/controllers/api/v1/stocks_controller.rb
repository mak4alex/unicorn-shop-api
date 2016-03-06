class Api::V1::StocksController < ApplicationController
  before_action :authenticate_api_user!, only: [:create, :update, :destroy]
  before_action :manager_only!,          only: [:create, :update, :destroy]
  before_action :set_stock,           only: [:show, :update, :destroy, :products]

  api! 'List all stocks'
  def index
    stocks = Stock.fetch(params)
    render json: stocks, meta: get_meta(stocks, params)
  end

  api! 'Show count of stocks'
  def count
    render json: { count: stock.count }
  end

  api! 'Show stock with id'
  def show
    render json: @stock
  end

  api! 'List products on stock'
  def products
    products = @stock.products.fetch(params)
    render json: { products: products, meta: get_meta(products, params) }
  end

  def_param_group :stock do
    param :stock, Hash, required: true, action_aware: true do
      param :title, String, required: true
      param :percent, String, required: true
    end
  end

  api! 'Create stock'
  param_group :stock
  def create
    @stock = stock.new(stock_params)
    if @stock.save
      render json: @stock, status: 201, location: [:api, @stock]
    else
      render json: { errors: @stock.errors }, status: 422
    end
  end

  api! 'Update stock with id'
  param_group :stock
  def update
    if @stock.update(stock_params)
      render json: @stock, status: 200, location: [:api, @stock]
    else
      render json: { errors: @stock.errors }, status: 422
    end
  end

  api! 'Destroy stock with id'
  def destroy
    @stock.destroy
    head 204
  end

  private

    def set_stock
      @stock = stock.find(params[:id])
    end

    def stock_params
      params.fetch(:stock, {}).permit( :title, :percent )
    end

end
