class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_api_user!, only: [:create, :update, :destroy]
  before_action :manager_only!,          only: [:create, :update, :destroy]
  before_action :set_category,           only: [:show, :update, :destroy, :products]

  api! 'List all categories'
  def index
    categories = Category.fetch(params)
    render json: categories, meta: get_meta(categories, params)
  end

  api! 'Show count of categories'
  def count
    render json: { count: Category.count }
  end

  api! 'Show category with id'
  def show
    render json: @category
  end

  api! 'List products on category'
  def products
    products = @category.products.fetch(params)
    render json: { products: products, meta: get_meta(products, params) }
  end

  def_param_group :category do
    param :category, Hash, required: true, action_aware: true do
      param :title, String, required: true
      param :description, String, required: true
      param :parent_category_id, String
    end
  end

  api! 'Create category'
  param_group :category
  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: 201, location: [:api, @category]
    else
      render json: { errors: @category.errors }, status: 422
    end
  end

  api! 'Update category with id'
  param_group :category
  def update
    if @category.update(category_params)
      render json: @category, status: 200, location: [:api, @category]
    else
      render json: { errors: @category.errors }, status: 422
    end
  end

  api! 'Destroy category with id'
  def destroy
    @category.destroy
    head 204
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.fetch(:category, {}).permit( :title, :description, :parent_category_id )
    end

end