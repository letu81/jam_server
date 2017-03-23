class CreateDeviceUsers < ActiveRecord::Migration
  def change
    create_table :device_users do |t|
      t.integer :device_id,    null: false
      t.integer :device_type,  null: false, :comments => "1 finger, 2 password, 3 card"
      t.integer :device_num,   null: false, :comments => "lock finger number"
      #t.string  :device_num,   null: false, :comments => "lock finger number"
      t.string  :name,         null: false

      t.timestamps null: false
    end

    add_index :device_users, :device_id, using: :btree
    add_index :device_users, [:device_id, :device_type], using: :btree
    add_index :device_users, [:device_id, :device_type, :device_num], name: "index_device_users_on_type_and_num", unique: true, using: :btree
  end
end