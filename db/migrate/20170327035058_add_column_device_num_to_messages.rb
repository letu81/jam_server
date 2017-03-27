class AddColumnDeviceNumToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :device_num, :integer, comments: "lock finger/password/card ID number"
  end
end