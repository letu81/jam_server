class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.integer  :user_id,   null: false
      t.integer  :device_id,    null: false
      t.integer  :ownership,    null: false, :defaut => 1, :comments => "1 owner, 2 share"
    end
    add_index :user_devices, :user_id, using: :btree
    add_index :user_devices, :device_id, using: :btree
    add_index :user_devices, [:user_id, :device_id, :ownership], name: "index_user_devices_on_owner", unique: true, using: :btree
  end
end
