Rails.application.routes.draw do

  # Setting up devise for users
  devise_for :users, :controllers => { registrations: "er_devise/registrations" }

  # Setting up the root of our website and public pages
  root to: 'home#index'
  get 'about' => 'home#about'

  scope :teller do
    get '/'      => 'tellers#index', as: :teller
    get '/*path' => 'tellers#index'
  end

  scope :customer do
    get '/'      => 'customers#index', as: :customer
    get '/*path' => 'customers#index'
  end

  # Api methods
  scope :format => true, :constraints => { :format => 'json' } do
    namespace :api do
      get 'payment_accounts/all'
      resources :customers do
        get 'current'
        resources :payment_accounts, shallow: true do
          post 'transfer', on: :member
          post 'credit-debit', on: :member
        end
      end
    end
  end
   
end
