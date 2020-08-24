Rails.application.routes.draw do
  root to: "home#index"

  resources :books
  resources :books_by_hand, only: %i[new create]
  resources :gatherings

  get "/login", to: "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
