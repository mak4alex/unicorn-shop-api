class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_member!,    only: [:index, :show]
  before_action :check_member!,           only: [:index, :show]
  before_action :set_order,               only: [:show, :update, :destroy]
  before_action :only_customer_own_order, only: [:show]
  before_action :authenticate_api_admin!, only: [:update, :destroy]

  api!
  def index
     if current_member.class == Admin
       orders =  Order.fetch(params)
     else
       orders = current_member.orders.fetch(params)
     end
     render json: orders, meta: get_meta(orders, params)
  end

  api!
  def show
    render json: @order
  end

  api!
  def create
    order = Order.make_order(order_params, current_member)
    if order.save
      OrderMailer.send_confirmation(order).deliver_now
      render json: order, status: 201, location: [:api, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  api!
  def update
    if @order.update(order_params)
      render json: @order, status: 200, location: [:api, @order]
    else
      render json: { errors: @order.errors }, status: 422
    end
  end

  api!
  def destroy
    @order.destroy
    head 204
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.fetch(:order, {}).permit( :total, :pay_type, :delivery_type, :comment, :status,
                                       contact: [ :email, :name, :phone, :country, :city, :address ],
                                       line_items: [:product_id, :quantity])
    end

    def only_customer_own_order
      access_denied unless current_member.class == Admin || @order.user_id == current_member.id
    end

end
