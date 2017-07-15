# frozen_string_literal: true
module API
  module V1
    module Resources
      class Versions < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :versions, desc: '版本相关接口' do
          desc '获取版本更新历史' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :mobile_system, type: String, desc: 'Mobile system'
          end
          post '/' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            versions = AppVersion.by_system(params[:mobile_system])
            data = []
            versions.each do |v|
              data << { id: v.id, code: v.code, name: v.name, content: v.content,
                        title: "佳安美智控#{v.name}主要更新",
                        published_on: v.created_at.strftime("%Y-%m-%d") }
            end
            return { code: 0, message: "ok", data: data }
          end

          desc '获取最新版本信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :mobile_system, type: String, desc: 'Mobile system'
          end
          post '/app/latest' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            version = AppVersion.latest_by_system(params[:mobile_system])
            if version
              data = { code: version.code, name: version.name, content: version.content, download_url: "http://jiaanmei.com/download" }
              return { code: 0, message: "ok", data: data }
            else
              return { code: 1, message: "ok", data: "" }
            end
          end
        end

      end
    end
  end
end