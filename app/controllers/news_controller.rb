class NewsController < ApplicationController
	def index
		@news = New.paginate page: params[:page]
	end

	def show
		@new = New.find_by id: params[:id]
	end
end
