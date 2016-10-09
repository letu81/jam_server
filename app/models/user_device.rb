class UserDevice < ActiveRecord::Base
	has_many :devices, :foreign_key => 'device_id'
end