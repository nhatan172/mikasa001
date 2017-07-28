class Article < ApplicationRecord
  self.per_page = 15

  searchkick merge_mappings: true, mappings: {
    article: {
      properties: {
        title: {type: "text", index: "true", boost: 10},
        content: {type: "text", index: "true", boost: 10},
        html_content: {type: "text", index: "true"}
      },
    }
  }
end
