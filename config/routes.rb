Rails.application.routes.draw do
  root to: "home#index"

  get "/login", to: "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
