class CreateBlockedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :blocked_users do |t|
      t.integer :blocked_by
      t.integer :blocked

      t.timestamps
    end
  end
end
