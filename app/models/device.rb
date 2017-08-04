class Device < ActiveRecord::Base
	STATUSES = {:not_register => 1, :registered => 2, :lock_on => 3, :lock_off => 4}

	has_one :device_uuid, :foreign_key => 'id'
	belongs_to :user_device, :foreign_key => 'id'

	def switch_lock_end
		if brand_id.blank?
			0
		else
			Brand::LOCK_END_ON.include?(brand_id) ? 1 : 0
		end
	end

	def pwd_info
		pwd_setting.blank? ? "2|1" : pwd_setting
	end

	def monitor_num
		monitor_sn.blank? ? "" : monitor_sn
    end

	def self.by_device(device_id)
		self.joins("INNER JOIN device_uuids ON device_uuids.id = devices.uuid
			        INNER JOIN kinds ON device_uuids.kind_id = kinds.id
			        INNER JOIN brands ON kinds.brand_id = brands.id")
		.where(:id => device_id)
		.select("devices.id, devices.brand_id, devices.name, devices.mac, devices.status_id, device_uuids.uuid as dev_uuid, 
			devices.pwd_setting, brands.name as brand_name, brands.support_phone, kinds.name as kind_name, 
			devices.monitor_sn, devices.port, device_uuids.password, device_uuids.device_category_id")
		.first
	end

	def self.by_user(user_id)
		self.joins("INNER JOIN user_devices ON user_devices.device_id = devices.id 
			        INNER JOIN device_uuids ON device_uuids.id = devices.uuid")
		.where(:user_devices => {:user_id => user_id})
		.select("devices.id, devices.brand_id, devices.name, devices.mac, devices.status_id, device_uuids.uuid as dev_uuid, 
			devices.pwd_setting, devices.monitor_sn, devices.port, device_uuids.password, device_uuids.device_category_id")
	end

	def self.by_user_and_device_name(user_id, name)
		self.joins("INNER JOIN user_devices ON user_devices.device_id = devices.id 
			        INNER JOIN device_uuids ON device_uuids.id = devices.uuid")
		.where("user_devices.user_id=? and devices.name like ?", user_id, "%#{name}%")
		.select("devices.id, devices.brand_id, devices.name, devices.mac, devices.status_id, device_uuids.uuid as dev_uuid, 
			devices.pwd_setting, devices.monitor_sn, devices.port, device_uuids.password, device_uuids.device_category_id")
	end

	def self.by_device_mac_pwd(mac, pwd)
		self.joins("INNER JOIN user_devices ON user_devices.device_id = devices.id 
			        INNER JOIN device_uuids ON device_uuids.id = devices.uuid")
		.where(:mac => mac, :device_uuids => {:password=> pwd})
		.select("devices.id, user_devices.user_id")
		.first
	end
end