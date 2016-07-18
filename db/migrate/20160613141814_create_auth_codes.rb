class CreateAuthCodes < ActiveRecord::Migration
  def change
    create_table :auth_codes do |t|
      t.string   "code",       limit: 255
      t.string   "mobile",     limit: 255
      t.boolean  "verified",               default: true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "c_type",     limit: 4
    end

    add_index :auth_codes, :code, using: :btree
    add_index :auth_codes, :mobile, using: :btree
  end
end
