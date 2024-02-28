class AddPrivacyToArticle < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :privacy, :string
  end
end
