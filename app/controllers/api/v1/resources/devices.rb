require 'base64'
require 'json'
require 'rest-client'
# frozen_string_literal: true
module API
  module V1
    module Resources
      class Devices < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :devices, desc: '设备相关接口' do

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
              datas << {device_id: device.id, device_token: device.password, device_type: DeviceCategory::NAMES[device.device_category_id],
                        device_uuid:device.dev_uuid, mac: device.mac, name: device.name, 
                        monitor_sn: device.monitor_sn.blank? ? "" : device.monitor_sn, status: device.status_id}
            end

            if Setting[:ez_expire_time].to_i < Time.now.to_i
                response = RestClient.post Setting.ez_base_url + Setting.ez_get_token_url, {appKey:Setting.ez_app_key, appSecret:Setting.ez_app_secret}
                if response.code == 200
                    result = JSON.parse(response.body)
                    code = result['code']
                    if code.to_i == 200
                        data = result['data']
                        Setting[:ez_access_token] = data['accessToken']
                        Setting[:ez_expire_time] = data['expireTime']/1000
                    else
                        p "get token error"
                    end
                else
                    p response.code 
                    p response.body
                end
            end
	          return { code: 0, message: "ok", data: datas, ez_data: {access_token: Setting[:ez_access_token], expire_time: Setting[:ez_expire_time]}} 
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
            return { code: 0, message: "ok", data: {name: device.name, type: DeviceCategory::NAMES[device.device_category_id], device_uuid: device.dev_uuid, 
                   mac: device.mac, status: device.status_id, monitor_sn: device.monitor_sn.blank? ? "" : device.monitor_sn, status_name: online_str} } 
          end

          desc '设备历史操作详情' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
            optional :page, type: Integer, desc: 'page'
          end
          post  '/history' do
            page = params[:page].to_i
            datas = []
            user = authenticate!
            device = Device.where(id: params[:device_id]).first
            messages = Message.smart_lock.user(user.id).device(device.id).published.page(page).per(default_page_size)
            messages.each do |msg|
              data = { id: msg.id, user_id: user.id, relative_time: relative_time_in_words(msg.created_at), 
                       oper_time: msg.created_at.strftime("%Y-%m-%d %H:%M:%S"), 
                       content: Message::CMD["#{msg.oper_cmd}"], avatar_path: msg.avatar_path, gif_path: msg.gif_path }
              if msg.oper_cmd.include?("open")
                username = msg.username.nil? ? user.username : msg.username
                datas << data.merge({user_name: " #{username}回家了"})
              else
                datas << data.merge({user_name: "【系统消息】"})
              end
            end
            return { code: 0, message: "ok", data: datas, total_pages: messages.total_pages, current_page: page } 
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
                device.update_attribute(:status_id, Device::STATUSES[:registered])
              when 'lock_off'
                p 'lock off'
                device.update_attribute(:status_id, Device::STATUSES[:lock_off])
              else
                p 'other'
            end

            return { code: 0, message: "ok", data: {status: device.status_id} } 
          end


          desc '更新设备端口' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_mac, type: String, desc: 'Device mac'
            requires :gateway_port, type: String, desc: 'Gateway port'
          end
          post  '/port/update' do
            user = authenticate!
            Device.where(mac: params[:device_mac]).update_all(port: params[:gateway_port])
            return { code: 0, message: "ok", data: "" } 
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
            if du && !params[:company].include?("ys7")
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
              if params[:company].include?("ys7")
                kind = Kind.find_or_create_by(name: params[:version], brand_id: Brand::NAMES[:hzys7])
                uuid = DeviceUuid.find_or_create_by(uuid: params[:device_id], password: params[:password], 
                  device_category_id: DeviceCategory::CATES[:monitor], kind_id: kind.id, status_id: DeviceUuid::STATUSES[:used])
                if uuid
                  device = Device.find_or_create_by(name: "监控", uuid: uuid.id, mac: "")
                  user_device = UserDevice.where(user_id: user.id, device_id: device.id).first
                  if user_device
                    return { code: 1, message: "您已添加过设备", data: "" }
                  else
                    UserDevice.create!(user_id: user.id, device_id: device.id, ownership: true)
                    return { code: 0, message: "设备添加成功", data: "" }
                  end
                else
                  return { code: 1, message: "您已添加过设备", data: "" }
                end
              else
                return { code: 1, message: "设备码或检验码不存在", data: "" }
              end
            end
          end

          desc '监听设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :device_mac, type: String, desc: 'Device mac'
            requires :device_token, type: String, desc: 'Device token'
            requires :device_cmd, type: String, desc: 'Device cmd'
            optional :lock_type, type: Integer, desc: 'Lock type'
            optional :device_num, type: Integer, desc: 'Device Num'
          end
          post  '/listen' do
            device = Device.by_device_mac_pwd(params[:device_mac], params[:device_token])
            return { code: 1, message: "设备不存在", data: "" } unless device
            unless params[:device_num].blank?
              msg = Message.new(user_id: device.user_id, device_id: device.id, oper_cmd: params[:device_cmd], lock_type: params[:lock_type].to_i, device_num: params[:device_num].to_i)
              msg.save if msg.valid?
            else
              msg = Message.new(user_id: device.user_id, device_id: device.id, oper_cmd: params[:device_cmd])
              msg.save if msg.valid?
            end
            return { code: 0, message: "", data: "ok" } 
          end

          desc '更新设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
            optional :device_name, type: String, desc: 'Device name'
            optional :monitor_sn, type: String, desc: 'Monitor SN'
          end
          post  '/update' do
            user = authenticate!
            device = Device.where(id: params[:device_id]).first
            return { code: 1, message: "设备不存在", data: {} } unless device
            if params[:device_name]
              device.update_attribute(:name, params[:device_name])
              return { code: 0, message: "", data: {} } 
            elsif params[:monitor_sn]
              device_uuid = DeviceUuid.where(uuid: params[:monitor_sn]).first
              if device_uuid
                device.update_attribute(:monitor_sn, params[:monitor_sn])
                return { code: 0, message: "ok", data: { password: device_uuid.password } } 
              else
                return { code: 1, message: "监控序列号不存在", data: {} } 
              end
            end
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