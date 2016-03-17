class Api::V1::ReviewsController < ApplicationController
  before_action :set_review,           only: [:show, :update, :destroy]
  before_action :authenticate_member!, only: [:create, :update, :destroy]
  before_action :check_member!, only: [:create, :update, :destroy]
  before_action :only_owner!,          only: [:update, :destroy]

  api! 'List all reviews'
  def index
    reviews = Review.search(params).fetch(params)
    render json: { reviews: reviews, meta: get_meta(reviews, params) }
  end

  api! 'Show review with id'
  def show
    render json: @review
  end

  def_param_group :review do
    param :product, Hash, required: true, action_aware: true do
      param :title, String
      param :body, String
      param :rating, String, required: true
      param :product_id, String, required: true
      param :image_ids, String
    end
  end

  api! 'Create review'
  param_group :review
  def create
    review = Review.new(review_params)
    review.user_id = current_api_user.id
    if review.save
      review.add_images(review_params[:image_ids])
      render json: review, status: 201, location: [:api, review]
    else
      render json: { errors: review.errors }, status: 422
    end
  end

  api! 'Update review with id'
  param_group :review
  def update
    if @review.update(review_params)
      render json: @review, status: 200, location: [:api, @review]
    else
      render json: { errors: @review.errors }, status: 422
    end
  end

  api! 'Destroy review with id'
  def destroy
    @review.destroy
    head 204
  end

  private

    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.fetch(:review, {}).permit(:title, :body, :rating, :product_id, image_ids: [])
    end

    def check_member!
      not_authorized unless current_member
    end

    def only_owner!
      access_denied unless current_member.class == Admin || @review.user_id == current_member.id
    end

end
