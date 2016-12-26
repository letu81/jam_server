# frozen_string_literal: true
module API
  module V1
    module Resources
      class Me < API::V1::Root
        helpers API::V1::Helpers::Application
        helpers API::V1::Helpers::UserParams

        resource :me, desc: '个人相关接口' do
          desc '个人信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/' do
            user = authenticate!
            datas = {:name => user.username, :mobile => user.mobile}
            p datas
            return { code: 0, message: "ok", data: datas } 
          end

          desc '消息列表' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/messages' do
            user = authenticate!
            hash = {"register" => "无线注册成功", "logout" => "删除无线成功",
                    "lock_on" => "允许近端开锁", "lock_off" => "禁止近端开锁", "new_pwd" => "获取动态密码",
                    "app_open" => "app开门", "pwd_open" => "密码开门", "card_open" => "IC卡开门",
                    "finger_open" => "指纹开门", "low_power" => "电量低，请及时更换电池", 
                    "doorbell" => "有客到，请开门", "tamper" => "暴力开门，小智提醒您注意安全并及时报警"}
            datas = []
            messages = Message.includes([:user, :device]).smart_lock.resent.user(user.id).published
            messages.each do |msg|
              data = { id: msg.id, user_id: msg.user_id, oper_time: msg.created_at.strftime('%Y-%m-%d %H:%M:%S'), content: + "#{msg.device.name}---" + hash["#{msg.oper_cmd}"] }
              if msg.oper_cmd.include?("open")
                datas << data.merge({user_name: " #{msg.user.username}回家了", })
              else
                datas << data.merge({user_name: "【系统消息】", })
              end
            end
            return { code: 0, message: "ok", data: datas } 
          end

          desc '反馈意见' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            optional :title, type: String, desc: 'title'
            optional :content, type: String, desc: 'content'
          end
          post '/feedback' do
            user = authenticate!
            return { code: 0, message: "ok", data: ""}
          end
        end
      end
    end
  end
end
