# == Route Map
#
#                     Prefix Verb   URI Pattern                           Controller#Action
#       payment_account_view GET    /payment_account/view(.:format)       payment_account#view
#        payment_account_new GET    /payment_account/new(.:format)        payment_account#new
#            payment_account POST   /payment_account(.:format)            payment_account#create
#                            DELETE /payment_account/:id(.:format)        payment_account#delete
# payment_account_delete_all POST   /payment_account/delete_all(.:format) payment_accounts#delete_all
#     payment_account_credit POST   /payment_account/credit(.:format)     payment_accounts#credit
#      payment_account_debit POST   /payment_account/debit(.:format)      payment_accounts#debit
#           new_user_session GET    /users/sign_in(.:format)              devise/sessions#new
#               user_session POST   /users/sign_in(.:format)              devise/sessions#create
#       destroy_user_session DELETE /users/sign_out(.:format)             devise/sessions#destroy
#              user_password POST   /users/password(.:format)             devise/passwords#create
#          new_user_password GET    /users/password/new(.:format)         devise/passwords#new
#         edit_user_password GET    /users/password/edit(.:format)        devise/passwords#edit
#                            PATCH  /users/password(.:format)             devise/passwords#update
#                            PUT    /users/password(.:format)             devise/passwords#update
#   cancel_user_registration GET    /users/cancel(.:format)               devise/registrations#cancel
#          user_registration POST   /users(.:format)                      devise/registrations#create
#      new_user_registration GET    /users/sign_up(.:format)              devise/registrations#new
#     edit_user_registration GET    /users/edit(.:format)                 devise/registrations#edit
#                            PATCH  /users(.:format)                      devise/registrations#update
#                            PUT    /users(.:format)                      devise/registrations#update
#                            DELETE /users(.:format)                      devise/registrations#destroy
#                            POST   /api/users.json(.:format)             api/registrations#create {:format=>"json"}
#                       root GET    /                                     home#index
#

Rails.application.routes.draw do

  get  'payment_accounts/view' => 'payment_account#view'
  get  'payment_accounts' => 'payment_account#new'

  post   'payment_accounts' => 'payment_account#create'
  delete 'payment_accounts/:id' => 'payment_account#delete', as: :payment_account
  delete 'payment_accounts' => 'payment_account#delete_all'

  post 'payment_accounts/:id/op' => 'payment_account#money_op', as: :payment_account_op

  devise_for :users
  post 'api/users.json', to: 'api/registrations#create', defaults: { format: 'json' }
  root to: 'home#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
