source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Making it easy to serialize models for client-side use
gem 'active_model_serializers', '~> 0.9.4'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Token based authentication for Rails JSON APIs. Designed to work with jToker and ng-token-auth.
gem 'devise_token_auth', '~> 0.1.37'

gem 'puma', '~> 3.4'

gem 'apipie-rails', '~> 0.3.5'
# Upload files, map them to a range of ORMs, store them on different backends.
gem 'carrierwave', '~> 0.10.0'
# Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick
gem 'mini_magick', '~> 4.4'

gem 'fog', '~> 1.37'
# Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and sophisticated paginator
gem 'kaminari', '~> 0.16.3'
# ActiveRecord backend for Delayed::Job, originally authored by Tobias Lütke
gem 'delayed_job_active_record', '~> 4.1'
# Ffaker generates dummy data.
gem 'ffaker', '~> 2.2'
# Extend ActiveRecord pluck to return hash instead of an array. Useful when plucking multiple columns.
gem 'pluck_to_hash', '~> 0.1.3'

gem 'rack-cors', :require => 'rack/cors'

group :production do
  gem 'pg', '~> 0.18.4'
  gem 'rails_12factor', '~> 0.0.3'
  gem 'fog-google', '~> 0.1.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Use mysql as the database for Active Record
  gem 'mysql2', '>= 0.3.13', '< 0.5'
  gem 'rspec-rails', '~> 3.4', '>= 3.4.2'
  gem 'factory_girl_rails', '~> 4.6'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.1'
  gem 'rspec-collection_matchers', '~> 1.1', '>= 1.1.2'
  gem 'email_spec', '~> 2.0'
end
