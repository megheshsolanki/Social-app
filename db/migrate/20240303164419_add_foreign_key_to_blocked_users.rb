class AddForeignKeyToBlockedUsers < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :blocked_users, :users, column: :blocked_by
    add_foreign_key :blocked_users, :users, column: :blocked
  end
end
