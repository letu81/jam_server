class AddNewPasswordToDeviceUuids < ActiveRecord::Migration
  def change
  	add_column :device_uuids, :new_password, :string

  	add_index :device_uuids, [:uuid, :password], using: :btree, unique: true
    add_index :device_uuids, [:uuid, :new_password], using: :btree, unique: true
  end
end