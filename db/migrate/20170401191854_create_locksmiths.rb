class CreateLocksmiths < ActiveRecord::Migration
  def change
    create_table :locksmiths do |t|
      t.string :name, null: false
      t.string :phone
      t.string :mobile
      t.string :company
      t.integer :district_code, null: false, comments: "对应区域"
      t.string :qq
      t.string :address
      t.string :certificate_number, comments: "备案号"
      t.string :avatar
      t.boolean :is_verified, null: false, default: false, comments: "是否已验证"

      t.text :company_info, limit:1000
      t.text :company_service, limit:1000

      t.timestamps null: false
    end

    add_index :locksmiths, [:name], using: :btree
    add_index :locksmiths, [:company], using: :btree
    add_index :locksmiths, [:mobile], using: :btree
    add_index :locksmiths, [:phone], using: :btree
    add_index :locksmiths, [:district_code], using: :btree
    add_index :locksmiths, [:certificate_number, :is_verified], using: :btree
  end
end