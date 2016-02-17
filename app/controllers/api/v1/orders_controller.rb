class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_api_user!

  def index
     if current_api_user.manager?
       respond_with Order.all
     else
       respond_with current_api_user.orders
     end
  end

end
