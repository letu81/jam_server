# frozen_string_literal: true
require 'mini_magick'
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
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            datas = {:id => user.id, :name => user.username, :mobile => user.mobile, :gender => "", :avatar => ""}
            return { code: 0, message: "ok", data: datas } 
          end

          desc '更新个人信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :name, type: String, desc: 'User name'
            #requires :gender, type: String, desc: 'User gender'
            requires :phone, type: String, desc: 'User phone'
          end
          post '/update' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            user.update_attributes({:username => params[:name], :mobile => params[:phone]})
            return { code: 0, message: "ok", data: "" } 
          end

          desc '更新个人地址' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :province, type: String, desc: 'User province'
            requires :city, type: String, desc: 'User city'
            requires :district, type: String, desc: 'User district'
            requires :address, type: String, desc: 'User address'
            requires :latitude, type: String, desc: 'User latitude'
            requires :longitude, type: String, desc: 'User longitude'
          end
          post '/location/update' do
            user = current_user
            unless user
              return { code: 401, message: "用户未登录", data: "" }
            end
            user.update_attributes({:address => params[:address], :latitude => params[:latitude], :longitude => params[:longitude]})
            if user.address_changed?
              UpdateDistrictCodeJob.set(queue: "update_districe_code").perform_later(user, params[:province], params[:city], params[:district])
            end
            return { code: 0, message: "ok", data: "" } 
          end

          desc '消息列表' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            optional :page, type: Integer, desc: 'page'
          end
          post '/messages' do
            page = params[:page].to_i
            user = current_user
            unless user
              return { code: 401, message: "用户未登录", data: "" }
            end
            datas = []
            messages = Message.includes([:user, :device]).smart_lock.user(user.id).published.page(page).per(default_page_size)
            messages.each do |msg|
              data = { id: msg.id, user_id: msg.user_id, relative_time: relative_time_in_words(msg.created_at),
                       oper_time: msg.created_at.strftime("%Y-%m-%d %H:%M:%S"), 
                       content: + "#{msg.device.name}---" + msg.content_detail, oper_cmd: msg.oper_cmd,
                       avatar_path: msg.avatar_path, gif_path: msg.gif_path }
              if msg.oper_cmd.include?("open")
                username = msg.username.nil? ? msg.user.username : msg.username
                datas << data.merge({user_name: " #{username}回家了"})
              else
                datas << data.merge({user_name: "【系统消息】"})
              end
            end
            return { code: 0, message: "ok", data: datas, total_pages: messages.total_pages, current_page: page } 
          end

          desc '删除消息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :message_id, type: Integer, desc: 'Message id'
          end
          post '/messages/destroy' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            message = Message.find_by(id: params[:message_id])
            if message
              message.update_attribute(:is_deleted, true) if message.user_id == user.id
              return { code: 0, message: "ok", data: "" }
            else
              return { code: 1, message: "error", data: "消息不存在或已被删除" } 
            end
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
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            return { code: 0, message: "ok", data: "" }
          end

          desc '合作伙伴' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/partners' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            brands = DeviceUuid.by_user(user.id)
            if brands.length > 0
              datas = []
              bs = Brand.where("status_id = ? AND id IN (?)", Brand::STATUSES[:active], brands.map(&:id))
              bs.each do |brand|
                datas << { id: brand.id, name: brand.name, full_name: brand.full_name }
              end
              return { code: 0, message: "ok", data: datas }
            else
              return { code: 0, message: "ok", data: [] }
            end
          end

          desc '配置帮助视频' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/video/lock_config' do
            Rails.logger.debug "=================="
            Rails.logger.debug File.exist?("public/videos/5/Q7.mp4")
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            brands = DeviceUuid.by_user(user.id)
            if brands.length > 0
              datas = []
              bs = Brand.by_ids(brands.map(&:id))
              bs.each do |brand|
                if File.exist?("public/videos/#{brand.id}/config/#{brand.name}.mp4")
                  datas << { id: brand.id, name: brand.name, path: "#{brand.id}/config/#{brand.name}.mp4" }
                end
              end
              return { code: 0, message: "ok", data: datas }
            else
              return { code: 0, message: "ok", data: [] }
            end
          end

          desc '更新头像' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :json, type: String, desc: 'User token'
            optional :avatar, type: String, desc: 'User avatar'
          end
          post '/update/avatar' do
            j = JSON.parse(params[:json])
            if params[:json].nil? || j["token"].nil?
              return { code: 1, message: "参数错误", data: { avatar: "" } }
            end
            user = User.where(private_token: j["token"]).first
            if user.blank?
              return { code: 1, message: "用户不存在", data: { avatar: "" } }
            end
            tmp = params[:avatar]
            if tmp.nil?
              return { code: 0, message: "ok", data: { avatar: "" } }
            else
              begin
                file = File.join("public/pictures/avatars", "file.jpg")
                File.open(file, "wb") { |f| f.write(tmp) }
                image = MiniMagick::Image.open(file)
                image.contrast
                image.resize "48x48!"
                filename = "#{user.id}_thumbnail.jpg"
                image.write("public/pictures/avatars/#{filename}")
                File.delete(file)
                if File.exist?("public/pictures/avatars/#{filename}")
                  user.update_attribute(:avatar, filename)
                  return { code: 0, message: "ok", data: { avatar: filename } }
                else
                  return { code: 0, message: "ok", data: { avatar: "" } }
                end
              rescue Exception => e
                p e.message
              end
            end
          end
        end
      end
    end
  end
end