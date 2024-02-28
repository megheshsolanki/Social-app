class AddVerificationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :verification, :boolean
  end
end
