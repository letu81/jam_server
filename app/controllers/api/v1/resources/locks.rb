# frozen_string_literal: true
module API
  module V1
    module Resources
      class Locks < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :locks, desc: '锁相关接口' do
          desc '用户信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device id'
            requires :lock_type, type: String, desc: 'Device id'
          end
          post '/users' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            datas = []
            page = params[:page].blank? ? 1 : params[:page].to_i
            users = DeviceUser.by_device_and_type(params[:device_id], params[:lock_type]).page(page).per(default_page_size)
            users.each do |user|
              datas << user
            end
            return { code: 0, message: "ok", data: datas, total_pages: users.total_pages, current_page: page } 
          end
          
          desc '添加用户' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device id'
            requires :lock_type, type: String, desc: 'Lock type'
            requires :device_num, type: String, desc: 'Device num'
            requires :name, type: String, desc: 'User name'
          end
          post '/add_user' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            lock_user = DeviceUser.new(device_id: params[:device_id], device_type: params[:lock_type], name: params[:name], device_num: params[:device_num])
            if lock_user.valid? && lock_user.save
              return { code: 0, message: "ok", data: ""}
            else
              return { code: 1, message: lock_user.errors.full_messages.to_sentence, data: "" }
            end
          end

          desc '更新用户' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device id'
            requires :name, type: String, desc: 'User name'
            requires :device_num, type: String, desc: 'Device num'
          end
          post '/update_user' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            lock_user = DeviceUser.where(id: params[:device_id]).first
            if lock_user
              if lock_user.update_attributes({:name => params[:name], :device_num => params[:device_num]})
                return { code: 0, message: "ok", data: ""}
              else
                return { code: 1, message: lock_user.errors.full_messages.to_sentence, data: "" }
              end
            else
              return { code: 1, message: "用户不存在", data: "" }
            end
            return { code: 0, message: "ok", data: datas } 
          end

          desc '删除用户' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :device_id, type: String, desc: 'Device id'
          end
          post '/remove_user' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            lock_user = DeviceUser.where(id: params[:device_id]).first
            if lock_user
              lock_user.destroy
              return { code: 0, message: "ok", data: ""}
            else
              return { code: 1, message: "用户不存在", data: "" }
            end
          end
        end
      end
    end
  end
end