class Api::V1::CategoriesController < ApplicationController
  respond_to :json
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    respond_with Category.all
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: 201, location: [:api, @category]
    else
      render json: { errors: @category.errors }, status: 422
    end
  end

  def update
    if @category.update(category_params)
      render json: @category, status: 200, location: [:api, @category]
    else
      render json: { errors: @category.errors }, status: 422
    end
  end

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
