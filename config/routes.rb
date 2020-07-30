Rails.application.routes.draw do
  root to: "home#index"

  resources :sessions, only: %i[new create destroy]
  get "/log_in", to: "sessions#new", as: :log_in
  delete "/log_out", to: "sessions#destroy", as: :log_out
end
