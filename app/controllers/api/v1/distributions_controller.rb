class Api::V1::DistributionsController < ApplicationController
  before_action :authenticate_api_admin!
  before_action :set_distribution, only: [:show, :update, :destroy]

  api! 'List all distributions'
  def index
    distributions = Distribution.fetch(params)
    render json: { distributions: distributions, meta: get_meta(distributions, params) }
  end

  api! 'Show distribution with id'
  def show
    render json: @distribution
  end

  def_param_group :distribution do
    param :distribution, Hash, required: true, action_aware: true do
      param :title, String, required: true
      param :body, String, required: true
      param :shop_id, String, required: true
    end
  end

  api! 'Create distribution'
  param_group :distribution
  def create
    distribution = Distribution.new(distribution_params)
    if distribution.save
      render json: distribution, status: 201, location: [:api, distribution]
    else
      render json: { errors: distribution.errors }, status: 422
    end
  end

  api! 'Update distribution with id'
  param_group :distribution
  def update
    if @distribution.update(distribution_params)
      render json: @distribution, status: 200, location: [:api, @distribution]
    else
      render json: { errors: @distribution.errors }, status: 422
    end
  end

  api! 'Destroy distribution with id'
  def destroy
    @distribution.destroy
    head 204
  end

  private

    def set_distribution
      @distribution = Distribution.find(params[:id])
    end

    def distribution_params
      params.fetch(:distribution, {}).permit(:title, :body, :shop_id)
    end

end
