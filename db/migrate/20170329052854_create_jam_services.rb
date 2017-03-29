class CreateJamServices < ActiveRecord::Migration
  def change
    create_table :jam_services do |t|
      t.integer  :user_id, null: false
      t.integer  :service_type, null: false, default: JamService::TAPES[:app_support], comments: "service type, 1: app support"
      t.string   :content, null: false, default: "", comments: "customer msg"
      t.boolean  :is_recall, null: false, default: false

      t.datetime :created_at
    end

    add_index :jam_services, [:user_id], using: :btree
    add_index :jam_services, [:is_recall], using: :btree
    add_index :jam_services, [:service_type, :is_recall], using: :btree
  end
end