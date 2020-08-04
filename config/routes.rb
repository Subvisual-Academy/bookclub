Rails.application.routes.draw do
  root to: "home#index"

  resources :books, only: %i[index show new create destroy]

  get "/login", to: "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
