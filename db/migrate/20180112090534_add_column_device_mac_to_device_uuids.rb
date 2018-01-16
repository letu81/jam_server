class AddColumnDeviceMacToDeviceUuids < ActiveRecord::Migration
  def change
 	add_column :device_uuids, :device_mac, :string, comments: "device mac, 433 module mac"
 	add_index :device_uuids, :device_mac, using: :btree
 	add_index :device_uuids, [:uuid, :password, :device_mac], name: "index_device_uuids_on_uuid_pwd_mac", using: :btree
  end
end