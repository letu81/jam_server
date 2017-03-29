class AddColumnMonitorSnToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :monitor_sn, :string
  	add_index  :devices, :monitor_sn, using: :btree
  end
end