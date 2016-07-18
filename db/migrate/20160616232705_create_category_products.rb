class CreateCategoryProducts < ActiveRecord::Migration
  def change
    create_table :category_products do |t|
      t.integer  :category_id, null: false
      t.integer  :product_id,    null: false
    end
    
    add_index :category_products, :category_id, using: :btree
    add_index :category_products, :product_id, using: :btree
    add_index :category_products, [:category_id,:product_id], name: 'index_category_products_on_cates_product', unique: true, using: :btree
  end
end
