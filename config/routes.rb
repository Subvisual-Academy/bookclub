Rails.application.routes.draw do
  root to: "home#index"

  resources :books, only: %i[index show new create destroy]

  resources :bookclub_gatherings

  get "/login", to: "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
