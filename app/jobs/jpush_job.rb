require 'jpush'
class JpushJob < ActiveJob::Base
  	queue_as :default

  	def perform(*args)
  		begin
  			message = args[0]
  			app_key = Setting.ez_app_key
  	        master_secret = Setting.ez_app_secret
  	        jpush = JPush::Client.new(app_key, master_secret)
  	        pusher = jpush.pusher

            username = message.username.nil? ? message.user.username : message.username
            title = message.oper_cmd.include?("open") ? "主人，#{username}回家了!" : "佳安美智控通知"

            notification = JPush::Push::Notification.new
  	        notification.set_android(
  	            alert: Message::CMD[message.oper_cmd],
  	            title: title,
  	            builder_id: 1,
  	            extras: {user_id: message.user_id, user_name: ''}
  	        )

      		audience = JPush::Push::Audience.new
      		audience.set_tag(message.user_id.to_s)

	        push_payload = JPush::Push::PushPayload.new(
                platform: 'all',
                audience: audience,
                notification: notification
            )
	        
	        pusher.push(push_payload)
	    rescue Exception => e
            p "JpushJob error...."
            p e.message
        end
  	end
end
