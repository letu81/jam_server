# frozen_string_literal: true
module API
  module V1
    module Resources
      class Users < API::V1::Root
        helpers API::V1::Helpers::UserParams

        resources :users, desc: 'Operations related to user management' do
          desc 'Create a new user' do
            headers API::V1::Defaults.client_auth_headers
            success API::V1::Entities::User
          end
          params do
            requires :email, type: String, desc: 'User email'
            requires :password, type: String, desc: 'User password'
            use :update
          end
          oauth2
          post '/' do
            user = ::Users::Create::Base.perform(declared(params)).user
            present_model user, with: API::V1::Entities::User
          end

          route_param :id do
            desc 'Get an existing user', headers: API::V1::Defaults.client_auth_headers
            params do
              requires :id, type: Integer, desc: 'The id of an existing user'
            end
            oauth2
            get do
              # TODO: user fetching, should we do this?
            end
          end
        end
      end
    end
  end
end
