Rails.application.routes.draw do
  
  root 'apidocs#swagger_ui'

  resources :apidocs, only: [:index] do
    collection do
      get 'swagger_ui'
    end
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      namespace :authorizations, path: '' do
        devise_scope :api_v1_authorizations_user do
          post '/login', to: 'authenticate#create'
          post '/register', to: 'register#create'
          delete '/revoke', to: 'authenticate#revoke'
          get '/user_list', to: 'authenticate#user_list'
        end
        devise_for :users, skip: %i[registrations sessions unlocks]
      end

      resources :posts do
        member do
          post :like_post
        end
      end
      resources :comments do
        member do
          post :like_comment
        end
      end
    end
  end
end
