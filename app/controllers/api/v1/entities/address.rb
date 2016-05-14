# frozen_string_literal: true
module API
  module V1
    module Entities
      class Address < Grape::Entity
        expose :address_line_1, as: :line1, documentation: { type: String, desc: 'The address line 1' }
        expose :address_line_2, as: :line2, documentation: { type: String, desc: 'The address line 2' }
        expose :city, documentation: { type: String, desc: 'The city' }
        expose :state, documentation: { type: String, desc: 'The state' }
        expose :zipcode, documentation: { type: String, desc: 'The zipcode' }
      end
    end
  end
end
