class UserDevice < ActiveRecord::Base
	has_many :devices, :foreign_key => 'device_id'

	scope :user, lambda { |user_id| where(user_id: user_id) }
end