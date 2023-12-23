Rails.application.routes.draw do
  root "dashboard#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  resource :session, only: [:new, :create, :destroy]
  resources :dashoard, only: [:index]
  resources :user_room_estimates, only: [:update]
  resources :users
  resources :rooms do
    resources :players, only: [:index]
  end

  post '/clear_all', to: 'user_room_estimates#clear_all'
  post '/show_estimates', to: 'user_room_estimates#show_estimates'
  post '/hide_estimates', to: 'user_room_estimates#hide_estimates'
  post '/hide_user', to: 'players#hide'
  post '/unhide_user', to: 'players#unhide'
end
