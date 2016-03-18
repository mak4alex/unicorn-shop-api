class Api::V1::FavouritesController < ApplicationController
  before_action :authenticate_member!
  before_action :check_member!


  api!
  def index
    if current_member.class == Admin
      favourites = Favourite.fetch(params)
    else
      favourites = current_member.favourites.fetch(params)
    end
    render json: favourites, meta: get_meta(favourites, params)
  end

  api!
  def create
    favourite = Favourite.new(user: current_member, product_id: favourite_params[:product_id])
    if favourite.save
      render json: favourite, status: 201, location: [:api, favourite]
    else
      render json: { errors: favourite.errors }, status: 422
    end
  end

  api!
  def destroy
    favourite = Favourite.find(params[:id])
    if current_member.class == Admin || current_member.id == favourite.user_id
      favourite.destroy
      head 204
    else
      access_denied
    end
  end

  private

    def favourite_params
      params.require(:favourite).permit(:product_id)
    end

end
