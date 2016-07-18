# frozen_string_literal: true
module API
  module V1
    module Resources
      class Devices < API::V1::Root

        resource :devices, desc: '设备相关接口[todo]' do

          desc '获取当前用户设备列表' do
            headers API::V1::Defaults.auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          get '/' do
            user = authenticate!
	    
          end


          desc '添加设备' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::Device
          end
          params do
            optional :token, type: String, desc: 'User token'
          end
          oauth2
          post  '/bind' do
            context = declared(params, include_missing: false).merge(user: current_user)
            present_model ::Me::Update::Base.perform(context).user, with: API::V1::Entities::User
          end

          desc '删除设备' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::Device
          end
          params do
            optional :token, type: String, desc: 'User token'
          end
          oauth2
          
          delete  '/destroy' do
            context = declared(params, include_missing: false).merge(user: current_user)
            present_model ::Me::Update::Base.perform(context).user, with: API::V1::Entities::User
          end
        end
      end
    end
  end
end
