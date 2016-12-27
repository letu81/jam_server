class Device < ActiveRecord::Base
	STATUSES = {:not_register => 1, :registered => 2, :lock_on => 3, :lock_off => 4}

	has_one :device_uuid, :foreign_key => 'uuid'
	belongs_to :user_device, :foreign_key => 'id'

	def self.by_user(user_id)
		self.joins(:user_device).includes(:device_uuid).where(:user_devices => {:user_id => user_id})
	end

	def self.by_device_mac_pwd(mac, pwd)
		self.joins("INNER JOIN user_devices ON user_devices.device_id = devices.id 
			        INNER JOIN device_uuids ON device_uuids.id = devices.uuid")
		.where(:mac => mac, :device_uuids => {:password=> pwd})
		.select("devices.id, user_devices.user_id")
		.first
	end
end