class AddColumnUsernameToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :username, :string

  	add_index :messages, :username, using: :btree
  end
end
