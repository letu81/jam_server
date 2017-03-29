# frozen_string_literal: true
module API
  module V1
    module Resources
      class JamServices < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :jam_services, desc: '售后服务相关接口' do
          desc '获取最新版本信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :service_type, type: String, desc: 'Service type'
          end
          post '/request' do
            user = authenticate!
            jam_service = JamService.new(user_id: user.id, service_type: params[:service_type])
            if jam_service.valid? && jam_service.save
              return { code: 0, message: "ok", data: "" }
            else
              return { code: 1, message: "error", data: "" }
            end
          end
        end

      end
    end
  end
end