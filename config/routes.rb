require 'api_constraints'

Rails.application.routes.draw do
  root to: 'application#welcome'
  apipie
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User',  at: 'user'
      mount_devise_token_auth_for 'Admin', at: 'admin'

      resources :users,         except: [:new, :edit]
      resources :categories,    except: [:new, :edit] do
        member do
          get 'products'
          get 'subcategories'
        end
        collection do
          get 'count'
          get 'menu'
        end      
      end
      resources :products,      only: [:index, :show, :create, :update, :destroy]
      resources :distributions, only: [:index, :show, :create, :update, :destroy]
      resources :images,        only: [:index, :show, :create, :update, :destroy]
      resources :orders,        only: [:index, :show, :create, :update, :destroy]
      resources :favourites,    only: [:index, :create, :destroy]
      resources :reviews,       only: [:index, :show, :create, :update, :destroy]
      resources :stocks,        only: [:index, :show, :create, :update, :destroy] do
        get 'products', on: :member
        get 'count',    on: :collection
      end
    end
  end
end
