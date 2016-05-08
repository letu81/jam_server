# frozen_string_literal: true
module API
  module V1
    module Entities
      class TruckVendor < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :description, documentation: {type: String, desc: 'brief desc here'}
        expose :facebook, documentation: {type: String, desc: 'brief desc here'}
        expose :hashtag, documentation: {type: String, desc: 'brief desc here'}
        expose :image, documentation: {type: String, desc: 'brief desc here'}
        expose :instagram, documentation: {type: String, desc: 'brief desc here'}
        expose :logo, documentation: {type: String, desc: 'brief desc here'}
        expose :menu, documentation: {type: String, desc: 'brief desc here'}
        expose :name, documentation: {type: String, desc: 'brief desc here'}
        expose :performance_score, documentation: {type: String, desc: 'brief desc here'}
        expose :phone_number, documentation: {type: String, desc: 'brief desc here'}
        expose :price_score, documentation: {type: String, desc: 'brief desc here'}
        expose :primary_category, documentation: {type: String, desc: 'brief desc here'}
        expose :secondary_category, documentation: {type: String, desc: 'brief desc here'}
        expose :slug, documentation: {type: String, desc: 'brief desc here'}
        expose :twitter, documentation: {type: String, desc: 'brief desc here'}
        expose :url, documentation: {type: String, desc: 'brief desc here'}
        expose :contact_name, documentation: {type: String, desc: 'brief desc here'}
        expose :contact_email, documentation: {type: String, desc: 'brief desc here'}
        expose :contact_phone, documentation: {type: String, desc: 'brief desc here'}
        expose :isFeatured, documentation: {type: String, desc: 'brief desc here'}

        # with_options(format_with: :iso_timestamp) do
        #   expose :created_at
        #   expose :updated_at
        # end

        private

        def url
          v1_truck_vendors_path(id: object.id)
        end

      end
    end
  end
end
