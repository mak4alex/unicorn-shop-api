require 'api_constraints'

Rails.application.routes.draw do
  apipie

  namespace :api, defaults: { format: :json } do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users,      only: [:index, :show, :create, :update, :destroy]
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :products,   only: [:index, :show, :create, :update, :destroy]
    end
  end

end
