class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer  "user_id", null: false
      t.integer  "device_id", null: false, :comments => "设备id"
      t.string   "device_type", null: false, :default => "lock", :comments => "设备类型"
      t.string   "oper_cmd", null: false
      t.boolean  "is_deleted", null: false, :default => false
      
      t.datetime :created_at
    end

    add_index "messages", ["user_id", "is_deleted"], name: "index_messages_on_user"
    add_index "messages", ["user_id", "device_type", "is_deleted"], name: "index_messages_on_user_all_devices"
    add_index "messages", ["user_id", "device_type", "device_id", "is_deleted"], name: "index_messages_on_user_devices"
  end
end