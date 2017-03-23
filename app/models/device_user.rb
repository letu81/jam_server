class DeviceUser < ActiveRecord::Base
	TYPES = {:finger => 1, :password => 2, :card => 3}

	has_many :devices, :foreign_key => 'device_id'

	validates :device_num, :uniqueness => {scope: [:device_id, :device_type]}
	validates :device_num, numericality: { greater_than: 0, less_than_or_equal_to: 20000 }  
	validates :device_num, presence: true, length: { maximum: 10, minimum: 1 }
	validates :name, presence: true, length: { maximum: 30, minimum: 1 }

    default_scope { order("id desc") }

	def self.by_device_and_type(device_id, lock_type)
		self.where(:device_id => device_id, :device_type => lock_type)
	end
end