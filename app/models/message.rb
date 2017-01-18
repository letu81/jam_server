class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :device
    
    default_scope { order("id desc") }

    scope :smart_lock, lambda { where(device_type: "lock") }
    scope :user, lambda { |user_id| where(user_id: user_id) }
    scope :device, lambda { |device_id| where(device_id: device_id) }
	scope :resent, lambda { where("created_at > ?", 1.days.ago) }
	scope :published, lambda { where(is_deleted: false) }
end