class Api::V1::CategoriesController < ApplicationController
  respond_to :json
  before_action :set_category, only: [:show, :update, :destroy]

  api! 'List all categories'
  def index
    respond_with Category.all
  end

  api! 'Show category with id'
  def show
    render json: @category
  end

  def_param_group :category do
    param :category, Hash, required: true, action_aware: true do
      param :title, String, required: true
      param :description, String, required: true
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
      params.require(:category).permit( :title, :description )
    end

end
