class CreateBlockedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :blocked_users do |t|
      t.integer :blocked_by_id
      t.integer :blocked_id

      t.timestamps
    end
  end
end
