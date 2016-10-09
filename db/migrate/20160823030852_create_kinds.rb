class CreateKinds < ActiveRecord::Migration
  def change
    create_table :kinds do |t|
      t.string   "name", null: false, :comments => "型号"
      t.integer  "brand_id", null: false
      t.integer  "status_id", null: false, :default => Kind::STATUSES[:active]
    end

    add_index "kinds", ["name"], using: :btree
    add_index "kinds", ["brand_id"], using: :btree
    add_index "kinds", ["status_id"], using: :btree
  end
end