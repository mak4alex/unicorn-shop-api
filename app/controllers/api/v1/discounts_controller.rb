class Api::V1::DiscountsController < ApplicationController
  before_action :authenticate_api_user!, only: [:create, :update, :destroy]
  before_action :manager_only!,          only: [:create, :update, :destroy]
  before_action :set_discount,           only: [:show, :update, :destroy, :products]

  api! 'List all discounts'
  def index
    discounts = Discount.fetch(params)
    render json: discounts, meta: get_meta(discounts, params)
  end

  api! 'Show count of discounts'
  def count
    render json: { count: Discount.count }
  end

  api! 'Show discount with id'
  def show
    render json: @discount
  end

  api! 'List products on discount'
  def products
    products = @discount.products.fetch(params)
    render json: { products: products, meta: get_meta(products, params) }
  end

  def_param_group :discount do
    param :discount, Hash, required: true, action_aware: true do
      param :title, String, required: true
      param :percent, String, required: true
    end
  end

  api! 'Create discount'
  param_group :discount
  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      render json: @discount, status: 201, location: [:api, @discount]
    else
      render json: { errors: @discount.errors }, status: 422
    end
  end

  api! 'Update discount with id'
  param_group :discount
  def update
    if @discount.update(discount_params)
      render json: @discount, status: 200, location: [:api, @discount]
    else
      render json: { errors: @discount.errors }, status: 422
    end
  end

  api! 'Destroy discount with id'
  def destroy
    @discount.destroy
    head 204
  end

  private

    def set_discount
      @discount = Discount.find(params[:id])
    end

    def discount_params
      params.fetch(:discount, {}).permit( :title, :percent )
    end

end
