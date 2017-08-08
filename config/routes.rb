Rails.application.routes.draw do
  root "static_pages#home"
  get "/searches", to: "searches#index"

  resources :articles, only: [:show, :index]
  resources :news, only: [:show, :index]
end
