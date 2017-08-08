class Article < ApplicationRecord
  self.per_page = 15

  searchkick batch_size: 200, merge_mappings: true,
    settings: {
      analysis: {
        analyzer: {
          vnanalysis: {
            tokenizer: "icu_tokenizer",
            filter: [
              "icu_folding",
              "icu_normalizer"
            ]
          }
        }
      }
    },
    mappings: {
      article: {
        properties: {
          title: {
            type: "text",
            index: "true",
            boost: 10,
            analyzer: "vnanalysis"
          },
          content: {
            type: "text",
            index: "true",
            boost: 10,
            analyzer: "vnanalysis"
          },
          html_content: {type: "text", index: "true"}
        }
      }
    }

  class << self
    def search_article_much_view
      Article.order(count_click: :desc).limit(5)
    end
  end
end
