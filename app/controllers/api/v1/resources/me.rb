# frozen_string_literal: true
module API
  module V1
    module Resources
      class Me < API::V1::Root
        helpers API::V1::Helpers::UserParams

        resource :me, desc: 'Operations related to current user' do
          desc 'Get current user' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::User
          end
          oauth2
          get '/' do
            present current_user, with: API::V1::Entities::User
          end

          desc 'Update a user' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::User
          end
          params do
            use :update
            optional :email, type: String, desc: 'User email'
          end
          oauth2
          patch '/' do
            context = declared(params, include_missing: false).merge(user: current_user)
            present_model ::Me::Update::Base.perform(context).user, with: API::V1::Entities::User
          end
        end
      end
    end
  end
end
