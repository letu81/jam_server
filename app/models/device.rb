class Device < ActiveRecord::Base
	STATUSES = {:not_register => 1, :registered => 2, :lock_on => 3, :lock_off => 4}

	has_one :device_uuid, :foreign_key => 'id'
	belongs_to :user_device, :foreign_key => 'id'

	def self.by_user(user_id)
		self.joins(:user_device).where(:user_devices => {:user_id => user_id})
	end
end