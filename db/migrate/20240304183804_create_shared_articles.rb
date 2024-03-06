class CreateSharedArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_articles do |t|
      t.integer :article_id
      t.integer :shared_by_id
      t.integer :owned_by_id
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
