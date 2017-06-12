class AddColumnToDeviceUuids < ActiveRecord::Migration
	def change
	  	add_column :device_uuids, :access_token, :string, comments: "monitor access_token"
	  	add_column :device_uuids, :expired_at, :integer, comments: "monitor expired_at"

	  	add_index :device_uuids, [:access_token], using: :btree
	  	add_index :device_uuids, [:expired_at], using: :btree
  	end
end