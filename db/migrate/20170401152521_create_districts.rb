class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :code, null: false, unique: true
      t.string :parent_code
      t.string :name, null: false
      t.string :pinyin, null: false
      t.string :abbr, null: false
      t.string :zip
      t.integer :level
      t.boolean :sensitive_areas, null: false, default: false

      t.timestamps null: false
    end

    add_index :districts, [:code], using: :btree, unique: true
    add_index :districts, [:parent_code], using: :btree
    add_index :districts, [:pinyin], using: :btree
    add_index :districts, [:abbr], using: :btree
    add_index :districts, [:level], using: :btree
    add_index :districts, [:zip], using: :btree
    add_index :districts, [:sensitive_areas], using: :btree
  end
end