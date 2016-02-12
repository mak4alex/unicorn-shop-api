Apipie.configure do |config|
  config.app_name                = 'MarketPlaceApi'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/apidocs'
  config.reload_controllers      = Rails.env.development?
  config.default_version         = '1'
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
