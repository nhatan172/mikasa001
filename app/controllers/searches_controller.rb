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
      @articles = Article.paginate page: params[:page]
    end
  end
end

