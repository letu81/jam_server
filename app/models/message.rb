class Message < ActiveRecord::Base
    serialize :ori_picture_urls, Hash
    
    CMD = {"register" => "无线注册成功", "logout" => "删除无线成功", 
           "sync_time" => "同步时间成功", "gateway_update" => "网关固件升级成功",
           "lock_on" => "允许近端开锁", "lock_off" => "禁止近端开锁", "new_pwd" => "生成临时密码",
           "app_open" => "app开门", "pwd_open" => "密码开门", "card_open" => "IC卡开门",
           "finger_add" => "添加指纹", "finger_del" => "删除指纹",
           "pwd_add" => "添加密码", "pwd_del" => "删除密码", 
           "card_add" => "添加IC卡", "card_del" => "删除IC卡",
           "finger_open" => "指纹开门", "low_power" => "电量低，请及时更换电池", 
           "illegal_key" => "机械钥匙非法开锁，小智提醒您注意安全并及时报警", 
           "illegal_try" => "非法开锁超过限次，小智提醒您注意安全并及时报警",
           "lctch_bolt" => "斜舌报警，小智提醒您注意安全并及时报警", 
           "dead_bolt" => "方舌信号，小智提醒您注意安全并及时报警",
           "reset" => "恢复出厂设置",
           "doorbell" => "有客人拜访，请开门", 
           "tamper" => "暴力开门，小智提醒您注意安全并及时报警"}

    validates :oper_cmd, length: { maximum: 30, minimum: 1 }, presence: true

    belongs_to :user
    belongs_to :device
    
    default_scope { order("id desc") }

    scope :smart_lock, lambda { where(device_type: "lock") }
    scope :user, lambda { |user_id| where(user_id: user_id) }
    scope :device, lambda { |device_id| where(device_id: device_id) }
	  scope :resent, lambda { where("created_at > ?", 1.days.ago) }
	  scope :published, lambda { where(is_deleted: false) }


    after_create :update_username, :update_lock_picture, :send_notification

    def update_username
        return if self.lock_type.nil? || self.device_num.to_i == 0
        begin
            MessageUpdateUsernameJob.set(queue: "msg_update_username").perform_later(self)
        rescue Exception => e
            p "update_lock_picture error...."
            p e.message
        end
    end

    def update_lock_picture
        if self.oper_cmd.include?("open") && self.device_type == "lock"
          begin
              YsCapturePictureJob.set(queue: "ys_capture").perform_later(self)
          rescue Exception => e
              p "update_lock_picture error...."
              p e.message
          end
        end
    end

    def send_notification
        begin
            JpushJob.set(queue: "notification_jpush").perform_later(self.id)
        rescue Exception => e
            p "send_notification error...."
            p e.message
        end
    end
    
end