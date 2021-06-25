Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/sitemaps', to: 'sitemaps#index', format: 'xml'
  get 'about', to: 'static_pages#about'
  get 'pricing', to: 'static_pages#pricing'

  resource :feedback, path: :contact_us, only: [:create, :new]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :accept_invites, only: %i[new create]

  namespace :account do
    resources :microposts, path: :feed, except: [:show, :edit]
    resources :gifts
    resources :users, except: [:create, :new]
    resource  :organization,
              only: [:edit, :update],
              controller: :organization
    resource  :profile,
              only: [:edit, :update],
              controller: :profile
    resources :organization_gifts, path: :rewards, only: [:index, :show]
    resources :invites, except: %i[edit update]
    resources :notifications, only: :index do
      post 'mark_all_as_read', on: :member
    end
    resources :reactions, only: [:create, :destroy]
    resources :comments, only: [:create]
    resources :favorite_gifts, only: [:index, :create, :destroy]
    resources :my_gifts, only: [:index, :show] do
      member do
        post 'receive'
      end
    end

    resource :transaction, only: [:create, :new], controller: :transaction
  end

  resources :posts

  namespace :admin do
    root to: 'admin#index'
    resources :organizations, only: [:index, :show]
    resources :feedbacks, only: [:index, :show]
    resources :users
  end
end
