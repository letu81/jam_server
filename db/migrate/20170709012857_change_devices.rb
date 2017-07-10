class ChangeDevices < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE `devices` DROP INDEX `index_devices_on_product_id`" 
  	execute "ALTER TABLE `devices` DROP INDEX `index_devices_on_product_activited`" 
  	remove_column :devices, :product_id

  	add_column :devices, :brand_id, :integer, null: false, default: 1

  	add_index :devices, :brand_id, using: :btree
  	add_index :devices, [:brand_id, :activited_at], name: "index_devices_on_brand_activited", using: :btree
  end
end