class AddColumnLockTypeToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :lock_type, :integer, comments: "lock finger/password/card"

  	add_index :messages, [:device_id, :lock_type, :device_num], using: :btree
  end
end