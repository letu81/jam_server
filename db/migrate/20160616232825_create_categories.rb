class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string  :name,         null: false
      t.integer :position,     null: false
    end
    
    add_index :categories, :name,  unique: true, using: :btree
    add_index :categories, :position,  unique: true, using: :btree
  end
end
