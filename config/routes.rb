Rails.application.routes.draw do
  get 'users/index'

  get 'users/new'

  get 'users/show'
  devise_for :users
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user
  match '/checkout' => 'reservations#checkout', :via => :post, :as => :checkout
  match '/return' => 'reservations#return', :via => :post, :as => :return
  resources :reservations
  resources :cars
  root 'application#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
