Rails.application.routes.draw do
  root "static_pages#home"
  get "/search", to: "static_pages#search"
  get "/about", to: "static_pages#about"
  resources :news,params: :doc_id, only: [:index, :show]
end
