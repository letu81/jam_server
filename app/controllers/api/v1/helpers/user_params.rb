# frozen_string_literal: true
module API
  module V1
    module Helpers
      module UserParams
        extend Grape::API::Helpers

        USER_TYPE = API::V1::Types::UserType

        params :update do
          optional :first_name, desc: 'User first name'
          optional :last_name, desc: 'User last name'
          optional :type, type: USER_TYPE, desc: USER_TYPE.desc, documentation: { param_type: :form }
          optional :phone_number, type: String, desc: 'The users phone number'
          optional :address, type: Hash do
            optional :line1, type: String, desc: 'The address line 1'
            optional :line2, type: String, desc: 'The address line 2'
            optional :state, type: String, desc: 'The state'
            optional :zipcode, type: String, desc: 'The zipcode'
            optional :city, type: String, desc: 'The city'
          end
        end
      end
    end
  end
end
