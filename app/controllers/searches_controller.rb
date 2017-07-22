class SearchesController < ApplicationController
  before_action :search_articles, only: :index

  def index
    render "articles/index"
  end

  private

  def search_articles
    if params[:query].length > 0
      if params[:group1] && params[:group2]
        if params[:group1] == t("app.search_box.filter.filter_2")
          if params[:group2] == t("app.search_box.filter.filter_3")
            @articles ||= Article.search params[:query],
              fields: ["content^10", "title^10"], operator: "or",
              per_page: 15, page: params[:page]
          elsif params[:group2] == t("app.search_box.filter.filter_4")
            @articles ||= Article.search params[:query],
              fields: ["content^10"], operator: "or",
              per_page: 15, page: params[:page]
          else
            @articles ||= Article.search params[:query],
              fields: ["title^10"], operator: "or",
              per_page: 15, page: params[:page]
          end
        else
          if params[:group2] == t("app.search_box.filter.filter_3")
            @articles ||= Article.search params[:query],
              fields: ["content^10", "title^10"], match: :phrase,
              per_page: 15, page: params[:page]
          elsif params[:group2] == t("app.search_box.filter.filter_4")
            @articles ||= Article.search params[:query],
              fields: ["content^10"], match: :phrase,
              per_page: 15, page: params[:page]
          else
            @articles ||= Article.search params[:query],
              fields: ["title^10"], match: :phrase,
              per_page: 15, page: params[:page]
          end
        end
      elsif params[:group1] && params[:group2] == nil
        if params[:group1] == t("app.search_box.filter.filter_2")
          @articles ||= Article.search params[:query],
            fields: ["content^10", "title^10"], operator: "or",
            per_page: 15, page: params[:page]
        else
          @articles ||= Article.search params[:query],
            fields: ["content^10", "title^10"], match: :phrase,
            per_page: 15, page: params[:page]
        end
      elsif params[:group1] == nil && params[:group2]
        if params[:group2] == t("app.search_box.filter.filter_3")
          @articles ||= Article.search params[:query],
            fields: ["content^10", "title^10"], match: :phrase,
            per_page: 15, page: params[:page]
        elsif params[:group2] == t("app.search_box.filter.filter_4")
          @articles ||= Article.search params[:query],
            fields: ["content^10"], match: :phrase, per_page: 15,
            page: params[:page]
        else
          @articles ||= Article.search params[:query],
            fields: ["title^10"], match: :phrase, per_page: 15,
            page: params[:page]
        end
      else
        @articles ||= Article.search params[:query],
          fields: ["content^10", "title^10"], match: :phrase,
          per_page: 15, page: params[:page]
      end
    else
      @articles = Article.paginate page: params[:page]
    end
  end
end
