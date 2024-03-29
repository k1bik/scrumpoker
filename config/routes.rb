Rails.application.routes.draw do
  root "dashboard#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  resource :session, only: %i[new create destroy]
  resources :dashoard, only: %i[index]
  resources :users, only: %i[new create edit update]
  resources :rooms do
    resources :players, only: %i[index]
  end

  post '/clear_all', to: 'user_room_estimates#clear_all'
  post '/show_estimates', to: 'user_room_estimates#show_estimates'
  post '/hide_estimates', to: 'user_room_estimates#hide_estimates'
  post '/toggle_visibility', to: 'players#toggle_visibility'
  patch '/set_estimate', to: 'user_room_estimates#set_estimate'
end
