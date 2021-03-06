class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   "title",          limit: 255
      t.string   "intro",          limit: 255
      t.string   "image",          limit: 255
      t.decimal  "low_price",                    precision: 8, scale: 2, default: 0.0
      t.decimal  "origin_price",                 precision: 8, scale: 2, default: 0.0

      t.string   "subtitle",       limit: 255
      t.boolean  "on_sale",                                              default: true
      t.string   "units",          limit: 255
      t.text     "note",           limit: 65535
      t.integer  "stock_count",    limit: 4,                             default: 1000
      t.string   "summary_image",  limit: 255

      t.boolean  "is_discount",                                          default: false
      t.datetime "discounted_at"
      t.integer  "discount_score", limit: 4,                             default: 0

      t.integer  "orders_count",   limit: 4,                             default: 0
      t.integer  "likes_count",    limit: 4,                             default: 0
      t.integer  "postion",        limit: 4,                             default: 0

      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "products", ["title"], using: :btree
    add_index "products", ["postion"], using: :btree
    add_index "products", ["on_sale"], using: :btree
    add_index "products", ["is_discount"], using: :btree
    add_index "products", ["on_sale", "is_discount"], using: :btree
  end
end
