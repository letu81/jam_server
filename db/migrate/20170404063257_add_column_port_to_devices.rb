class AddColumnPortToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :port, :integer, comments: "gateway socket number"
  	add_index :devices, [:port], using: :btree
  end
end