class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def welcome
    respond_to do |format|
      format.html send_file "#{Rails.root}/public/index.html", type: 'text/html'
      format.json { render json: { welcome: 'Hello from unicorn online-shop web-service',
                                   date: Date.now }, status: 200 }
    end
  end

  def not_found
    api_error(status: 404, errors: ['Resource not found.'])
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    render json: {errors: errors}.to_json, status: status
  end

end
