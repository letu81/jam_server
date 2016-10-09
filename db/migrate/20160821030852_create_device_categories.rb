class CreateDeviceCategories < ActiveRecord::Migration
  def change
    create_table :device_categories do |t|
      t.string   "name", :comments => "设备类型"
    end

    add_index "device_categories", ["name"], using: :btree
  end
end