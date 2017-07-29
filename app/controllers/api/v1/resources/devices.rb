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
            optional :page, type: Integer, desc: 'page'
          end
          post '/' do
            user = current_user
            unless user
              return { code: 401, message: "用户未登录", data: "" }
            end
            page = params[:page].to_i
            devices = Device.by_user(user.id).page(page).per(default_page_size)
            datas = []
            devices.each do |device|
              datas << {device_id: device.id, device_token: device.password, device_type: DeviceCategory::NAMES[device.device_category_id],
                        device_uuid: device.dev_uuid, mac: device.mac, name: device.name, 
                        monitor_sn: device.monitor_sn.blank? ? "" : device.monitor_sn, 
                        port: device.port.blank? ? "" : device.port, 
                        status: device.status_id}
            end
	          return { code: 0, message: "ok", data: datas, total_pages: devices.total_pages, current_page: page, ez_data: {access_token: '', expire_time: 0}} 
          end

          desc '搜索设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :query, type: String, desc: 'Query string'
            optional :page, type: Integer, desc: 'page'
          end
          post  '/search' do
            user = current_user
            unless user
              return { code: 401, message: "用户未登录", data: "" }
            end
            page = params[:page].to_i
            devices = Device.by_user_and_device_name(user.id, params[:query].strip).page(page).per(default_page_size)
            datas = []
            devices.each do |device|
              datas << {device_id: device.id, device_token: device.password, device_type: DeviceCategory::NAMES[device.device_category_id],
                        device_uuid:device.dev_uuid, mac: device.mac, name: device.name, 
                        monitor_sn: device.monitor_sn.blank? ? "" : device.monitor_sn, 
                        port: device.port.blank? ? "" : device.port, 
                        status: device.status_id}
            end
            return { code: 0, message: "ok", data: datas, total_pages: devices.total_pages, current_page: page } 
          end

          desc '设备详情' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
          end
          post  '/show' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            device = Device.by_device(params[:device_id])
            return { code: 1, message: "设备不存在，请刷新设备列表", data: "" } unless device
            online_str = "在线"
            return { code: 0, message: "ok", data: {name: device.name, type: DeviceCategory::NAMES[device.device_category_id], device_uuid: device.dev_uuid, 
                   brand_name: device.brand_name, kind_name: device.kind_name, support_phone: device.support_phone,
                   mac: device.mac, status: device.status_id, monitor_sn: device.monitor_sn.blank? ? "" : device.monitor_sn, 
                   port: device.port.blank? ? "" : device.port, status_name: online_str} } 
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
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
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
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
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
            #requires :token, type: String, desc: 'User token'
            requires :device_mac, type: String, desc: 'Device mac'
            requires :gateway_port, type: String, desc: 'Gateway port'
            requires :gateway_version, type: String, desc: 'Gateway Version'
          end
          post  '/port/update' do
            Device.where(mac: params[:device_mac]).update_all(port: params[:gateway_port])
            # todo update params[:gateway_version]
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
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            du = DeviceUuid.where(uuid: params[:device_id], password: params[:password]).first
            if du && !params[:company].include?("ys7")
              case du.status_id
              when DeviceUuid::STATUSES[:not_use]
                Device.transaction do
                  kind = du.kind
                  device = Device.new(name: du.device_category.name, brand_id: kind.brand_id, uuid: du.id, mac: params[:device_mac])
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
                  return { code: 1, message: "该设备已被使用", data: "" }
                  #UserDevice.create!(user_id: user.id, device_id: device.id, ownership: false)
                  #return { code: 0, message: "设备添加成功,但其他用户也添加过该设备", data: "" }
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
                  device = Device.find_or_create_by(name: "监控", brand_id: Brand::NAMES[:hzys7], uuid: uuid.id, mac: "")
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
                return { code: 1, message: "设备码或校验码不存在", data: "" }
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
              if params[:device_cmd] == "reset"
                device.update_attribute(:status_id, Device::STATUSES[:not_register])
              end
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
            optional :device_mac, type: String, desc: 'Device mac'
            optional :monitor_sn, type: String, desc: 'Monitor SN'
          end
          post  '/update' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
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
            elsif params[:device_mac]
              device.update_attribute(:mac, params[:device_mac])
              return { code: 0, message: "ok", data: {} } 
            end
          end

          desc '更新监控设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :monitor_sn, type: String, desc: 'Monitor SN'
            requires :access_token, type: String, desc: 'Access Token'
            requires :expired_at, type: String, desc: 'Expired At'
          end
          post  '/monitor/update' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            DeviceUuid.where(uuid: params[:monitor_sn]).update_all(access_token: params[:access_token], expired_at:params[:expired_at].to_i)
            return { code: 0, message: "ok", data: {} } 
          end

          desc '删除设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device uuid'
          end
          post  '/destroy' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
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


          desc '删除监控设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device uuid'
          end
          post '/monitor/destroy' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            du = DeviceUuid.where(uuid: params[:device_id]).first
            return { code: 1, message: "设备不存在", data: "" } unless du
            devices = Device.where(uuid: du.id)
            if devices.length > 0
              Device.transaction do
                devices.each do |device|
                  uds = UserDevice.where(user_id:user.id, device_id:device.id)
                  uds.each do |ud|
                    ud.destroy
                  end
                  device.destroy
                end
                du.destroy
              end
            else
              du.destroy 
            end
            return { code: 0, message: "ok", data: "ok" } 
          end
        end
      end
    end
  end
end