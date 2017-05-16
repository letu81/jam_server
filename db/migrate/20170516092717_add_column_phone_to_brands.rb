class AddColumnPhoneToBrands < ActiveRecord::Migration
  def change
  	add_column :brands, :sales_phone, :string, comments: "sales phone number"
  	add_column :brands, :support_phone, :string, comments: "support phone number"
  end
end