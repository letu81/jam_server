class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string   "name", null: false, :comments => "品牌"
      t.string   "identifier", null: false
    end

    add_index "brands", ["name"], using: :btree
    add_index "brands", ["identifier"], using: :btree
  end
end