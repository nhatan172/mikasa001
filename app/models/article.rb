class Article < ApplicationRecord
  self.per_page = 15
  searchkick
end
Article.reindex
