class AddColumnToBrands < ActiveRecord::Migration
  def change
  	add_column :brands, :full_name, :string, null: false
  	add_column :brands, :status_id, :integer, null: false, default: 1, comments: "1 active, 2 disable"

  	add_index :brands, [:status_id], using: :btree
  end
end