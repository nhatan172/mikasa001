Rails.application.routes.draw do
  root "static_pages#home"
  get "/search", to: "static_pages#search"
  get "/about", to: "static_pages#about"
end
