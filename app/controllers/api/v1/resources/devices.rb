require 'socket'
require 'base64'
require 'json'
# frozen_string_literal: true
module API
  module V1
    module Resources
      class Devices < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :devices, desc: '设备相关接口[todo]' do

          desc '获取当前用户设备列表' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/' do
            user = authenticate!
            devices = Device.by_user(user.id)
            datas = []
            devices.each do |device|
              datas << {device_id: device.id, device_token: device.password, device_type: '门锁',
                        mac: device.mac, name: device.name, status: device.status_id}
            end
	          return { code: 0, message: "ok", data: datas } 
          end

          desc '设备详情' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
          end
          post  '/show' do
            user = authenticate!
            device = Device.by_device(params[:device_id])
            return { code: 1, message: "设备不存在，请刷新设备列表", data: "" } unless device
            online_str = "在线"
            return { code: 0, message: "ok", data: {name: device.name, type: "门锁", uuid: device.dev_uuid, mac: device.mac, device_token:device.password, status: device.status_id, status_name: online_str} } 
          end

          desc '设备历史操作详情' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
          end
          post  '/history' do
            hash = {"register" => "无线注册成功", "logout" => "删除无线成功",
                    "lock_on" => "允许近端开锁", "lock_off" => "禁止近端开锁", "new_pwd" => "生成动态密码",
                    "app_open" => "app开门", "pwd_open" => "密码开门", "card_open" => "IC卡开门",
                    "finger_open" => "指纹开门", "low_power" => "电量低，请及时更换电池", 
                    "doorbell" => "有客到，请开门", "tamper" => "暴力开门，小智提醒您注意安全并及时报警"}
            datas = []
            user = authenticate!
            device = Device.where(id: params[:device_id]).first
            messages = Message.smart_lock.user(user.id).device(device.id).published.limit(50)
            messages.each do |msg|
              data = { id: msg.id, user_id: user.id, oper_time: msg.created_at.strftime('%Y-%m-%d %H:%M:%S'), content: hash["#{msg.oper_cmd}"] }
              if msg.oper_cmd.include?("open")
                datas << data.merge({user_name: " #{user.username}回家了", })
              else
                datas << data.merge({user_name: "【系统消息】", })
              end
            end
            return { code: 0, message: "ok", data: datas } 
          end

          desc '操作设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
          end
          post  '/cmd' do
            user = authenticate!
            device = Device.where(id: params[:device_id]).first
            return { code: 1, message: "设备不存在，请刷新设备列表", data: "" } unless device
            
            msg = Message.new(user_id: user.id, device_id: device.id, oper_cmd: params[:cmd])
            msg.save if msg.valid?

            case params[:cmd]
              when 'register'
                p 'register'
                device.update_attribute(:status_id, Device::STATUSES[:registered])
              when 'logout'
                p 'logout'
                device.update_attribute(:status_id, Device::STATUSES[:not_register])
              when 'lock_on'
                p 'lock on'
                device.update_attribute(:status_id, Device::STATUSES[:lock_on])
              when 'lcok_off'
                p 'lock off'
                device.update_attribute(:status_id, Device::STATUSES[:lock_off])
              else
                p 'other'
            end

            return { code: 0, message: "ok", data: {status: device.status_id} } 
          end

          desc '添加设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_mac, type: String, desc: 'Device mac'
            requires :device_id, type: String, desc: 'Device uuid'
            requires :password, type: String, desc: 'Device password'
          end
          post  '/bind' do
            user = authenticate!
            du = DeviceUuid.where(uuid: params[:device_id], password: params[:password]).first
            if du
              case du.status_id
              when DeviceUuid::STATUSES[:not_use]
                Device.transaction do 
                  device = Device.new(name: du.device_category.name, uuid: du.id, mac: params[:device_mac])
                  if device.valid? && device.save
                    du.update_attribute(:status_id, DeviceUuid::STATUSES[:used])
                    UserDevice.find_or_create_by!(user_id: user.id, device_id: device.id)
                  end
                end
                return { code: 0, message: "设备添加成功", data: "" }
              when DeviceUuid::STATUSES[:used]
                user_device = UserDevice.where(user_id: user.id, device_id: device.id).first
                if user_device
                  return { code: 1, message: "您已添加过设备", data: "" }
                else
                  UserDevice.create!(user_id: user.id, device_id: device.id, ownership: false)
                  return { code: 0, message: "设备添加成功,但其他用户也添加过该设备", data: "" }
                end
              when DeviceUuid::STATUSES[:discard]
                return { code: 1, message: "设备码已过期", data: "" }
              else
                return { code: 1, message: "设备添加失败,请稍后再试", data: "" }
              end
            else
              return { code: 1, message: "设备码或检验码不存在", data: "" }
            end
          end

          desc '监听设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :device_mac, type: String, desc: 'Device mac'
            requires :device_token, type: String, desc: 'Device token'
            requires :device_cmd, type: String, desc: 'Device cmd'
          end
          post  '/listen' do
            device = Device.by_device_mac_pwd(params[:device_mac], params[:device_token])
            return { code: 1, message: "设备不存在", data: "" } unless device
            msg = Message.new(user_id: device.user_id, device_id: device.id, oper_cmd: params[:device_cmd])
            msg.save if msg.valid?
            return { code: 0, message: "", data: "ok" } 
          end

          desc '更新设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
            requires :device_name, type: String, desc: 'Device name'
          end
          post  '/update' do
            user = authenticate!
            device = Device.where(id:params[:device_id]).first
            return { code: 1, message: "设备不存在", data: "" } unless device
            device.update_attribute(:name, params[:device_name])
            return { code: 0, message: "", data: "ok" } 
          end

          desc '删除设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device uuid'
          end
          post  '/destroy' do
            user = authenticate!
            device = Device.where(id: params[:device_id]).first
            return { code: 1, message: "设备不存在，请刷新设备列表", data: "" } unless device
            owner_device = UserDevice.where(user_id:user.id, device_id:device.id, ownership:true).first
            if owner_device
              Device.transaction do
                user_device = UserDevice.where(device_id:device.id, ownership:false).first
                if user_device
                  user_device.update_attribute(:ownership, true)
                else
                  device_uuid = DeviceUuid.where(id:device.uuid).first
                  device_uuid.update_attribute(:status_id, DeviceUuid::STATUSES[:not_use]) if device_uuid
                  device.update_attribute(:mac, "")
                end
                Message.where(user_id:user.id).update_all("is_deleted = true")
                owner_device.destroy
              end
            else
              user_device = UserDevice.where(user_id:user.id, device_id:device.id, ownership:false).first
              user_device.destroy if user_device
            end
            return { code: 0, message: "ok", data: "ok" } 
          end
        end
      end
    end
  end
end