class ArticlesController < ApplicationController
  def show
    @article = Article.find_by id: params[:id]
    count = @article.count_click + 1
    @article.update_attributes count_click: count
  end

  def index
    @articles = Article.paginate page: params[:page]
  end
end
