Rails.application.routes.draw do
  root "static_pages#home"
  get "/searches", to: "searches#index"

  resources :articles, param: :doc_id, only: [:show, :index]
  resources :news, param: :doc_id, only: [:show, :index]
end
