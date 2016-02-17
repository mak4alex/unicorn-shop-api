class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_api_user!
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :only_customer_own_order, only: [:show]

  def index
     if current_api_user.manager?
       respond_with Order.all
     else
       respond_with current_api_user.orders
     end
  end

  def show
    respond_with @order
  end

  def create
    order = Order.make_order(order_params, current_api_user)
    if order.save
      OrderMailer.send_confirmation(order).deliver_now
      render json: order, status: 201, location: [:api, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end


  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:total, :pay_type, line_items: [:product_id, :quantity])
    end

    def only_customer_own_order
        access_denied unless current_api_user.manager? || @order.user_id == current_api_user.id
    end

end
