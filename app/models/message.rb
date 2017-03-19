require 'jpush'
class Message < ActiveRecord::Base
    validates :oper_cmd, length: { maximum: 30, minimum: 1 }, presence: true

	belongs_to :user
	belongs_to :device
    
    default_scope { order("id desc") }

    scope :smart_lock, lambda { where(device_type: "lock") }
    scope :user, lambda { |user_id| where(user_id: user_id) }
    scope :device, lambda { |device_id| where(device_id: device_id) }
	scope :resent, lambda { where("created_at > ?", 1.days.ago) }
	scope :published, lambda { where(is_deleted: false) }


  	after_create :send_nootifycation

  	def send_nootifycation
 		begin
	  		app_key = "f380bae15326074cded980af"
	        master_secret = "216ff40fb5019459d9ae2fe1"
	        jpush = JPush::Client.new(app_key, master_secret)
	        pusher = jpush.pusher

	        notification = JPush::Push::Notification.new
	        notification.set_android(
	            alert: "主人，图图回家了!",
	            title: "密码开门",
	            builder_id: 1,
	            :extras => {:user_id => self.user_id, :user_name => ''}
	        )

	        audience = JPush::Push::Audience.new
	        pusher.push(push_payload)
        rescue Exception => e
            p "send_nootifycation error...."
            p e.message
        end
  	end
end