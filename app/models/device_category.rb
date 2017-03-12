class DeviceCategory < ActiveRecord::Base
	CATES = {:lock => 1, :socket => 2, :monitor => 6}
	NAMES = {1 => "门锁", 2 => "插座", 6 => "监控"}
	belongs_to :device_uuid
	validates :name, :uniqueness => true
end