class AddForeignKeysToSharedArticles < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :shared_articles, :articles, column: :article_id
    add_foreign_key :shared_articles, :users, column: :shared_by_id
    add_foreign_key :shared_articles, :users, column: :owned_by_id
  end
end
