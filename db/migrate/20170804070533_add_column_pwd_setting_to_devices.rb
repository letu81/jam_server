class AddColumnPwdSettingToDevices < ActiveRecord::Migration
  def change
 	add_column :devices, :pwd_setting, :string, comments: "lock temp password setting"
 	add_index :devices, :pwd_setting, using: :btree
  end
end