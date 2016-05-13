# frozen_string_literal: true
module API
  module V1
    module Entities
      class User < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :id, documentation: { type: Integer, desc: 'Unique identifier for the user.' }
        expose :url, documentation: { type: String, desc: 'The url for the resource' }
        expose :email, documentation: { type: String, desc: 'The email address' }
        expose :type, documentation: { type: String, desc: 'The user type' }
        expose :first_name, documentation: { type: String, desc: 'The user first name' }
        expose :last_name, documentation: { type: String, desc: 'The user last name' }
        expose :address, using: API::V1::Entities::Address, documentation: { type: 'API::V1::Entities::Address' }
        expose :phone_number, documentation: { type: String, desc: 'The users phone number' }

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
