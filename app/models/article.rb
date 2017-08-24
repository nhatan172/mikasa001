class Article < ApplicationRecord
  has_many :parts, class_name: 'Part', foreign_key: 'law_id'
  has_many :chapters, class_name: 'Chapter', foreign_key: 'law_id'
  has_many :sections, class_name: 'Section', foreign_key: 'law_id'
  has_many :laws, class_name: 'Law', foreign_key: 'law_id'
  has_many :items, class_name: 'Item', foreign_key: 'law_id'
  has_many :points, class_name: 'Point', foreign_key: 'law_id'
  
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
          index_html: {
            type: "text",
            index: "true"
          },
          full_html: {
            type: "text",
            index: "true"
          },
          public_day: {
            type: "date",
            index: "true"
          }
        }
      }
    }

  class << self
    def search_article_much_view
      Article.order(count_click: :desc).limit(5)
    end

    def search_article_newest
      Article.order(public_day: :desc).limit(4)
    end

    def filter_by_type opts = {}
      article_type = opts[:article_type]
      if article_type != nil
        self.where article_type: article_type
      end
    end
  end
end
