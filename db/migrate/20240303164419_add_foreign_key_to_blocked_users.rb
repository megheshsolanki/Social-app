class AddForeignKeyToBlockedUsers < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :blocked_users, :users, column: :blocked_by_id
    add_foreign_key :blocked_users, :users, column: :blocked_id
  end
end
