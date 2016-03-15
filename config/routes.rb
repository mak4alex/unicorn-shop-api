require 'api_constraints'

Rails.application.routes.draw do
  root to: 'application#welcome'
  apipie
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users,      only: [:index, :show, :create, :update, :destroy]
      resources :categories, only: [:index, :show, :create, :update, :destroy] do
        get 'products',      on: :member
        get 'subcategories', on: :member
        get 'count',         on: :collection
      end
      resources :products,   only: [:index, :show, :create, :update, :destroy]
      resources :images,     only: [:index, :show, :create, :update, :destroy]
      resources :orders,     only: [:index, :show, :create, :update, :destroy]
      resources :reviews,    only: [:index, :show, :create, :update, :destroy]
      resources :stocks,     only: [:index, :show, :create, :update, :destroy] do
        get 'products', on: :member
        get 'count',    on: :collection
      end
    end
  end
end
