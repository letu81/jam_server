# frozen_string_literal: true
module API
  module V1
    module Resources
      class Versions < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :versions, desc: '版本关接口' do
          desc '获取最新版本信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :mobile_system, type: String, desc: 'Mobile system'
          end
          post '/app/latest' do
            user = authenticate!
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