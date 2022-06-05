Rails.application.routes.draw do

  resources :roles
  resources :styles
  resources :bookings
  resources :rooms
  resources :users

  mount ForestLiana::Engine => '/forest'

  # For details on the DSL available within this file, 
  # see https://guides.rubyonrails.org/routing.html
  get "welcome/index"
  get "welcome/servicios"

  root to: "welcome#index" 
  
   
  get '/registro', to: 'users#new'


  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get "password", to: "passwords#edit", as: :edit_password
  patch "password", to: "passwords#update"

  patch "make_reception", to: "users#make_reception"
  patch "make_admin", to: "users#make_admin"

end
