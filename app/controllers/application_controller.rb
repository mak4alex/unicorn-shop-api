class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session


  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Max-Age'] = '1000'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, Client-Security-Token, Accept-Encoding'
  end

  rescue_from ActiveRecord::RecordNotFound,  with: :not_found

  def welcome
    respond_to do |format|
      format.html send_file "#{Rails.root}/public/index.html", type: 'text/html'
      format.json { render json: { welcome: 'Hello from unicorn online-shop web-service',
                                   date: Date.now }, status: 200 }
    end
  end

  def manager_only!
    access_denied unless current_api_user.manager?
  end

  def access_denied
    api_error(status: 403, errors: ['Error 403 Access Denied/Forbidden.'])
  end

  def not_found
    api_error(status: 404, errors: ['Resource not found.'])
  end

  def bad_request
    api_error(status: 400, errors: ['The request could not be understood by the server due to malformed syntax.'])
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    render json: {errors: errors}.to_json, status: status
  end


  protected

    def get_meta (collection, params)
      meta = {}
      meta[:pagination] = pagination(collection, params) if params[:page].present?
      meta[:sort] = params[:sort] if params[:sort].present?
      meta[:filter] = params[:filter] if params[:filter].present?
      meta
    end

    def pagination(paginated_array, params)
      { page: params[:page].to_i,
        per_page: params[:per_page].to_i,
        total_pages: paginated_array.total_pages,
        total_objects: paginated_array.total_count }
    end

    def configure_permitted_parameters
      parameters = [:name, :sex, :phone, :country, :city, :address, :birthday]
      devise_parameter_sanitizer.for(:sign_up) << parameters
      devise_parameter_sanitizer.for(:account_update) << parameters
    end

end
