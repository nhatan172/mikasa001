class SearchesController < ApplicationController
  before_action :search_articles, only: :index

  def index
    render "articles/index"
  end

  private

  def search_match_phrase
    if params[:group2_1] == t("app.search_box.filter.filter_4")
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query],
          match: :phrase, order: {public_day: :desc},
          per_page: 15, page: params[:page]
      else
        @articles = Article.search params[:query],
          match: :phrase, order: {public_day: :asc},
          per_page: 15, page: params[:page]
      end
    else
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query],
          match: :phrase, order: {effect_day: :desc},
          per_page: 15, page: params[:page]
      else
        @articles = Article.search params[:query],
          match: :phrase, order: {effect_day: :asc},
          per_page: 15, page: params[:page]
      end
    end

    return @articles
  end

  def search_match_word
    if params[:group2_1] == t("app.search_box.filter.filter_4")
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query], operator: "or",
          match: :word, order: {public_day: :desc},
          per_page: 15, page: params[:page]
      else
        @articles = Article.search params[:query],
          match: :word, order: {public_day: :asc}, operator: "or",
          per_page: 15, page: params[:page]
      end
    else
      if params[:group2_2] == t("app.search_box.filter.filter_6")
        @articles = Article.search params[:query], operator: "or",
          match: :word, order: {effect_day: :desc},
          per_page: 15, page: params[:page]
      else
        @articles = Article.search params[:query], operator: "or",
          match: :word, order: {effect_day: :asc},
          per_page: 15, page: params[:page]
      end
    end

    return @articles
  end

  def filter_by_article_type
    @articles = Article.search where: {article_type: params[:article_type]},
      per_page: 15, page: params[:page]
  end

  def filter_by_year_issued
    from_year = Time.parse params[:from_year] + '-1-1'
    to_year = Time.parse params[:to_year] + '-12-31'
    date_range = {}
    date_range[:gte] = from_year
    date_range[:lte] =to_year
    @articles = Article.search where: {public_day: date_range},
      per_page: 15, page: params[:page]
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
        @articles = Article.paginate page: params[:page]
      end
    end
  end
end

