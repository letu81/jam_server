# frozen_string_literal: true
module API
  module V1
    module Resources
      class Messages < API::V1::Root

        resource :messages, desc: '消息相关接口' do

          desc '获取消息列表' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::Device
          end
          params do
            optional :token, type: String, desc: 'User token'
          end
          oauth2
          get '/' do
            context = declared(params, include_missing: false).merge(user: current_user)
            present_model ::Me::Update::Base.perform(context).user, with: API::V1::Entities::User
          end
      

          
        end
      end
    end
  end
end
