class CreateAddressesTables < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer  "user_id",    null: false
      t.string   "name"
      t.string   "mobile",     null: false
      t.string   "region",     null: false
      t.string   "address",    null: false
      t.boolean  "is_default", null: false, default: false
    
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index :addresses, :user_id, using: :btree
    add_index :addresses, [:user_id, :is_default], name: "index_default_address_on_user_id", using: :btree
    add_index :addresses, :mobile, using: :btree
  end
end
