# frozen_string_literal: true
module API
  module V1
    module Helpers
      module UserParams
        extend Grape::API::Helpers

        USER_TYPE = API::V1::Types::UserType

        params :update do
          optional :mobile, type: String, desc: 'The users phone number'
          optional :username, desc: 'User name'
          optional :address, type: Hash do
            optional :name, documentation: { type: String, desc: 'The name' }
            optional :mobile, documentation: { type: String, desc: 'The mobile' }
            optional :address, documentation: { type: String, desc: 'The address' }
            optional :region, documentation: { type: String, desc: 'The zipcode' }
          end
        end
      end
    end
  end
end
