require 'api_constraints'

Rails.application.routes.draw do
  root to: 'application#welcome'
  apipie
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(default: true) do
      mount_devise_token_auth_for 'User',  at: 'user'
      mount_devise_token_auth_for 'Admin', at: 'admin', skip: [:registrations]

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
      resources :products,      except: [:new, :edit]
      resources :distributions, except: [:new, :edit]
      resources :images,        except: [:new, :edit]
      resources :orders,        except: [:new, :edit]
      resources :favourites,    only:   [:index, :create, :destroy]
      resources :reviews,       except: [:new, :edit]
      resources :stocks,        except: [:new, :edit] do
        get 'products', on: :member
        get 'count',    on: :collection
      end
    end
  end
end
