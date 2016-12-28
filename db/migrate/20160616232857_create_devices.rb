class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string  :name,          null: false, :default => "门锁"
      t.integer :product_id,    null: false,  :default => 1
      t.integer :uuid,  null: false
      t.boolean :is_online,  null: false,  :default => false
      t.integer :status_id, null: false, :default => Device::STATUSES[:not_register]
      t.string  :mac,    :default => ""
      
      t.datetime :activited_at
      t.datetime :last_request
    end

    add_index :devices, :name, using: :btree
    add_index :devices, :product_id, using: :btree
    add_index :devices, :uuid, unique: true, using: :btree

    add_index :devices, :activited_at, using: :btree
    add_index :devices, [:product_id, :activited_at], name: "index_devices_on_product_activited", using: :btree
  end
end