class ArticlesController < ApplicationController
  def show
    @article = Article.find_by doc_id: params[:doc_id]
  end

  def index
    @articles = Article.paginate page: params[:page]
  end
end
