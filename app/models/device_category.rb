class DeviceCategory < ActiveRecord::Base
	CATES = {:lock => 1, :socket => 2}
	belongs_to :device_uuid
	validates :name, :uniqueness => true
end