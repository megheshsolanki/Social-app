class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.string :status

      t.timestamps
    end
  end
end
