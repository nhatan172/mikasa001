class NewsController < ApplicationController
	def index
		@news = New.all	
	end

	def show
		@new = New.find_by doc_id: params[:id]
	end
end
