# frozen_string_literal: true
module API
  module V1
    module Entities
      class Device < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher
        
        expose :name, documentation: { type: String, desc: '设备名' }
      end
    end
  end
end