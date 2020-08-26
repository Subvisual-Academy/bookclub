Rails.application.routes.draw do
  root to: "gatherings#index"

  resources :books, only: %i[index show new create destroy]

  resources :gatherings

  resources :notifications, only: %i[create]

  get "/login", to: "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
