class Api::V1::SearchesController < ApplicationController
  before_action :search_articles, only: :index

  def index
    # render "articles/index"
    page_number = 0
    articlesCount = @articles.count
    limit_page = (articlesCount)%6 == 0 ? (articlesCount/6) : (articlesCount/6 + 1) 
    if params[:page]
      if params[:page] >  limit_page
        current_page = limit_page
      elsif params[:page] < 1
        current_page = 1
      else
        current_page = params[:page]
      end
    else
      current_page = 1
    end
    if @articles
      render json: {
        current_page: page_number,
        limit_page: limit_page,
        articles: @articles[(current_page-1)*6,6].as_json(only: [:id, :title, :public_day, :effect_day, :effect_status])
      }, status: :ok
    else 
      render json: {
        articles: null,
      }, status: :ok
    end
  end

  private

  def search_match_phrase
    if params[:group2_1] == t("app.search_box.filter.filter_4")
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query],
          match: :phrase, order: {public_day: :desc}
      else
        @articles = Article.search params[:query],
          match: :phrase, order: {public_day: :asc}
      end
    else
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query],
          match: :phrase, order: {effect_day: :desc}
      else
        @articles = Article.search params[:query],
          match: :phrase, order: {effect_day: :asc}
      end
    end

    return @articles
  end

  def search_match_word
    if params[:group2_1] == t("app.search_box.filter.filter_4")
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query], operator: "or",
          match: :word, order: {public_day: :desc}
      else
        @articles = Article.search params[:query],
          match: :word, order: {public_day: :asc}, operator: "or"
      end
    else
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query], operator: "or",
          match: :word, order: {effect_day: :desc}
      else
        @articles = Article.search params[:query], operator: "or",
          match: :word, order: {effect_day: :asc}
      end
    end

    return @articles
  end

  def filter_by_article_type
    @articles = Article.search where: {article_type: params[:article_type]}
  end

  def filter_by_year_issued
    from_year = Time.parse params[:from_year] + '-1-1'
    to_year = Time.parse params[:to_year] + '-12-31'
    date_range = {}
    date_range[:gte] = from_year
    date_range[:lte] =to_year
    @articles = Article.search where: {public_day: date_range}
  end

  def search_articles
    if params[:query] && params[:query].length > 0
      if params[:group1]
        if params[:group1] == t("app.search_box.filter.filter_1")
          @articles = search_match_phrase
        elsif params[:group1] == t("app.search_box.filter.filter_2")
          @articles = search_match_word
        end
      else
        @articles = search_match_phrase
      end
    else
      if params[:article_type]
        @articles = filter_by_article_type
      elsif params[:agency_issued]
      elsif params[:from_year] and params[:to_year]
        @articles = filter_by_year_issued
      else
        @articles = Article.all
      end
    end
  end
end

