# frozen_string_literal: true
module API
  module V1
    module Resources
      class Me < API::V1::Root
        helpers API::V1::Helpers::UserParams

        resource :me, desc: '个人相关接口' do
          desc 'Get current user' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::User
          end
          oauth2
          get '/' do
            present current_user, with: API::V1::Entities::User
          end

          desc '反馈意见' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::User
          end
          params do
            optional :title, type: String, desc: 'title'
            optional :content, type: String, desc: 'content'
          end
          oauth2
          post '/feedback' do
            context = declared(params, include_missing: false).merge(user: current_user)
            present_model ::Me::Update::Base.perform(context).user, with: API::V1::Entities::User
          end
        end
      end
    end
  end
end
