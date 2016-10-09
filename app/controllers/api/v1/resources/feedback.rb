# frozen_string_literal: true
module API
  module V1
    module Resources
      class Feedback < API::V1::Root

        resource :feedback, desc: '反馈相关接口[OK]' do

          desc '获取当前用户反馈列表' do
            headers API::V1::Defaults.auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          get '/' do
            user = authenticate!
          end


          desc '添加反馈' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::Feedback
          end
          params do
            requires :content, type: String, desc: '反馈意见'
            optional :contact, type: String, desc: '联系方式'
            optional :token, type: String, desc: 'User token'
          end
          oauth2
          post  '/' do
            context = declared(params, include_missing: false).merge(user: current_user)
            present_model ::Me::Update::Base.perform(context).user, with: API::V1::Entities::User
          end

        end
      end
    end
  end
end
