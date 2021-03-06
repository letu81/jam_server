require 'jpush'
class JpushJob < ActiveJob::Base
  	queue_as :low_priority

  	def perform(*args)
  		  begin
  			    message_id = args[0]
            message = Message.where(id: message_id).first
  			    app_key = Setting.jpush_app_key
  	        master_secret = Setting.jpush_app_secret
  	        jpush = JPush::Client.new(app_key, master_secret)
  	        pusher = jpush.pusher

            username = message.username.nil? ? message.user.username : message.username
            
            notification = JPush::Push::Notification.new
            if message.oper_cmd.include?("open")
                alert = "主人，#{username}回家了!"
                notification.set_android(
                    alert: alert,
                    title: message.content_detail,
                    builder_id: 1,
                    extras: {user_id: message.user_id, user_name: ''}
                ).set_ios(
                    alert: alert,
                    sound: nil,
                    badge: 0,
                    contentavailable: true,
                    mutablecontent: nil,
                    category: nil,
                    extras: {user_id: message.user_id, user_name: ''}
                )
            else
                title = "佳安美智控通知"
                notification.set_android(
                    alert: message.content_detail,
                    title: title,
                    builder_id: 1,
                    extras: {user_id: message.user_id, user_name: ''}
                ).set_ios(
                    alert: message.content_detail,
                    sound: nil,
                    badge: 0,
                    contentavailable: true,
                    mutablecontent: nil,
                    category: nil,
                    extras: {user_id: message.user_id, user_name: ''}
                )
            end

      		audience = JPush::Push::Audience.new
      		#audience.set_tag(message.user_id.to_s)
            audience.set_alias(message.user_id.to_s).set_tag_not(["logout"])

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
