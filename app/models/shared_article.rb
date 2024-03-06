class SharedArticle < ApplicationRecord
    belongs_to :shared_article, class_name: "Article", foreign_key: "article_id"
    belongs_to :owned_by, class_name: "User", foreign_key: "owned_by_id"
    belongs_to :shared_by, class_name: "User", foreign_key: "shared_by_id"
end
