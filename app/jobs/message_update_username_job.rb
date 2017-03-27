class MessageUpdateUsernameJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
  	begin
    	message = args[0]
    	user = DeviceUser.where(device_id: message.device_id, device_type: message.lock_type, device_num: message.device_num).first
    	if user
    		message.update_attribute(:username, user.name)
    	else
    		types = {1 => "指纹", 2 => "密码", 3 => "IC卡"}
    		message.update_attribute(:username, "##{message.device_num}#{types[message.device_num]}")
    	end
    rescue Exception => e
        p "MessageUpdateUsernameJob error...."
        p e.message
    end
  end
end