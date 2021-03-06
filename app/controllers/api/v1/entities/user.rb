# frozen_string_literal: true
module API
  module V1
    module Entities
      class User < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :id, documentation: { type: Integer, desc: 'Unique identifier for the user.' }
        expose :mobile, documentation: { type: String, desc: 'The users phone number' }
        expose :username, documentation: { type: String, desc: 'The username' }
        expose :token,   documentation: { type: String, desc: 'The authentication_token' }
        expose :address, using: "API::V1::Entities::Address", documentation: { type: 'API::V1::Entities::Address' }
        
        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :updated_at
        end

        private

        def url
          v1_users_path(id: object.id)
        end

        def address
          SimpleDelegator.new(object)
        end
      end
    end
  end
end
