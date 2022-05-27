Rails.application.routes.draw do

  resources :roles
  resources :styles
  resources :bookings
  resources :rooms

  mount ForestLiana::Engine => '/forest'

  # For details on the DSL available within this file, 
  # see https://guides.rubyonrails.org/routing.html
  get "welcome/index"
  get "welcome/servicios"

  root to: "welcome#index" 
  
   
  get '/registro', to: 'users#new'

  resources :users

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'




  
#  namespace :api do

 #   namespace :auth do
  #    post 'login', action: :login, controller: :auth
   # end

    #namespace :v1 do

     # get "get_users", action: :getUsers, controller: :users
     # post "add_user", action: :addUser, controller: :users
     # get "show_user", action: :showUser, controller: :users
     # put "update_user", action: :updateUser, controller: :users
     # delete "delete_user", action: :deleteUser, controller: :users

     # resources :users
    #end
 # end

#  namespace :api do
 #   namespace :v1 do
  #    resources :users
   # end
#  end

end
