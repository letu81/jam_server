require 'socket'
require 'base64'
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
              datas << {device_id: device.id, device_type: '门锁', name: device.name, status: device.status_id}
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
            device = Device.includes(:device_uuid).where(id: params[:device_id]).first
            return { code: 1, message: "设备不存在，请刷新设备列表", data: "" } unless device
            return { code: 0, message: "ok", data: {name: device.name, type: "门锁", uuid: device.device_uuid.uuid, status: device.status_id, status_name: "在线"} } 
          end

          desc '设备历史操作详情' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: Integer, desc: 'Device id'
          end
          post  '/history' do
            user = authenticate!
            datas = []
            datas << { id: 1, user_id: 1, user_name: "tutu回家了", oper_time: "3分钟前", content: "动态密码开门" }
            #datas << { id: 2, user_id: 1, user_name: "tutu回家了", oper_time: "2小时前", content: "一号指纹开门" }
            p datas
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
            p "device cmd"
            socket = TCPSocket.new '183.62.232.142', 6009
            #socket = TCPSocket.new '192.168.0.100', 6009
            tcp_token = (Digest::MD5.hexdigest "#{SecureRandom.urlsafe_base64(nil, false)}-#{params[:device_id]}-#{params[:cmd]}-#{Time.now.to_i}")
            send_data = '{"mac":"test1", "cmd":"open"}'
            socket.puts(send_data)
            #socket.puts("#{params[:cmd].bytes.to_a.map{|x| '0x'+x.to_i.to_s(16)}.join('')}")
            socket.flush
            socket.close
            device = Device.where(id: params[:device_id]).first
            return { code: 1, message: "设备不存在，请刷新设备列表", data: "" } unless device
            case params[:cmd]
            when '7E000022A0'
              p 'add'
              device.update_attribute(:status_id, Device::STATUSES[:registered])
            when '7E000023A1'
              p 'sub'
              device.update_attribute(:status_id, Device::STATUSES[:not_register])
            when '003'
              p 'lock on'
              device.update_attribute(:status_id, Device::STATUSES[:lock_on])
            when '004'
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
                  device = Device.new(name: du.device_category.name, uuid: du.id)
                  if device.valid? && device.save
                    du.update_attribute(:status_id, DeviceUuid::STATUSES[:used])
                    UserDevice.find_or_create_by!(user_id: user.id, device_id: device.id)
                  end
                end
                return { code: 0, message: "设备添加成功", data: "" }
              when DeviceUuid::STATUSES[:used]
                return { code: 1, message: "设备码已被使用", data: "" }
              when DeviceUuid::STATUSES[:discard]
                return { code: 1, message: "设备码已过期", data: "" }
              else
                return { code: 1, message: "设备添加失败,请稍后再试", data: "" }
              end
            else
              return { code: 1, message: "设备码或检验码不存在", data: "" }
            end
          end

          desc '删除设备' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device uuid'
          end
          delete  '/destroy' do
            user = authenticate!
            p "destroy device"
            return { code: 0, message: "ok", data: "" } 
          end
        end
      end
    end
  end
end