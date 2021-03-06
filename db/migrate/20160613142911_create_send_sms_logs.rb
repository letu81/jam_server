class CreateSendSmsLogs < ActiveRecord::Migration
  def change
    create_table :send_sms_logs do |t|
      t.string   "mobile",            limit: 255
      t.integer  "send_type",         limit: 4
      t.integer  "sms_total",         limit: 4,   default: 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "first_sms_sent_at"
    end

    add_index :send_sms_logs, [:mobile, :send_type], name: "index_mobile_type_on_sms_logs", using: :btree
  end
end
