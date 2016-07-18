# frozen_string_literal: true
module API
  module V1
    module Entities
      class Address < Grape::Entity
        expose :name, as: :name, documentation: { type: String, desc: 'The name' }
        expose :mobile, documentation: { type: String, desc: 'The mobile' }
        expose :address, documentation: { type: String, desc: 'The address' }
        expose :region, documentation: { type: String, desc: 'The zipcode' }
      end
    end
  end
end
