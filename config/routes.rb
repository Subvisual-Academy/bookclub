Rails.application.routes.draw do
  root to: "gatherings#index"

  namespace :books do
    get "/manual_import/new", to: "manual_import#new"
    post "/manual_import", to: "manual_import#create"
  end

  resources :books

  resources :gatherings do
    resources :notifications, only: %i[create], module: :gatherings
  end

  get "book/search", to: "autocomplete#search_book"
  get "users/search", to: "autocomplete#search_user"

  get "/login", to: "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end
