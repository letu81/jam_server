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
            user = authenticate!
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
            user = authenticate!
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
            user = authenticate!
            datas = []
            messages = Message.includes([:user, :device]).smart_lock.user(user.id).published.page(page).per(default_page_size)
            messages.each do |msg|
              data = { id: msg.id, user_id: msg.user_id, relative_time: relative_time_in_words(msg.created_at),
                       oper_time: msg.created_at.strftime("%Y-%m-%d %H:%M:%S"), 
                       content: + "#{msg.device.name}---" + Message::CMD["#{msg.oper_cmd}"],
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
