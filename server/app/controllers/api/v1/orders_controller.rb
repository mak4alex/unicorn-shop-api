class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_api_user!
  before_action :manager_only!, only: [:update, :destroy]
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :only_customer_own_order, only: [:show]

  def index
     if current_api_user.manager?
       orders =  Order.fetch(params)
     else
       orders = current_api_user.orders.fetch(params)
     end
     render json: orders, meta: get_meta(orders, params)
  end

  def show
    render json: @order
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
      params.fetch(:order, {}).permit( :total, :pay_type, :delivery_type, :comment,
                                       contact: [ :email, :name, :phone, :country, :city, :address ],
                                       line_items: [:product_id, :quantity])
    end

    def only_customer_own_order
      access_denied unless current_api_user.manager? || @order.user_id == current_api_user.id
    end

end
