class AddColumnDistrictCodeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :district_code, :string
  	add_column :users, :address, :string
  	add_column :users, :latitude, :float
  	add_column :users, :longitude, :float

    add_index  :users, :address, using: :btree
  	add_index  :users, :district_code, using: :btree
  	add_index  :users, [:latitude, :longitude], using: :btree
  end
end