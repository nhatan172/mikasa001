require 'api_constraints'

Rails.application.routes.draw do
	
	root "static_pages#home"
	get "/searches", to: "searches#index"
	resources :articles, only: [:show, :index]
	resources :news, only: [:show, :index]

	namespace :api, defaults: { format: :json } do
	    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
	      # We are going to list our resources here
			get "/searches", to: "searches#index"
			resources :articles, only: [:show, :index]
			resources :news, only: [:show, :index]
	  	end
	  end
end
