class CreateDeviceUuids < ActiveRecord::Migration
  def change
    create_table :device_uuids do |t|
      t.string   "uuid"
      t.string   "password"
      t.integer  "device_category_id", null: false, :default => DeviceCategory::CATES[:lock], :comments => "设备类型"
      t.integer  "kind_id", null: false, :comments => "型号"
      t.integer  "status_id", null: false, :default => DeviceUuid::STATUSES[:not_use]
      
      t.timestamps null: false
    end

    add_index "device_uuids", ["uuid"], using: :btree
    add_index "device_uuids", ["status_id"], using: :btree
    add_index "device_uuids", ["device_category_id"], using: :btree
    add_index "device_uuids", ["kind_id"], using: :btree
    add_index "device_uuids", ["uuid", "status_id"], using: :btree
  end
end