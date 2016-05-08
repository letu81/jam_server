# frozen_string_literal: true
module API
  module V1
    module Entities
      class Venue < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :venue_id, documentation: {type: String, desc: 'brief desc here'}
        expose :added_manually, documentation: {type: String, desc: 'brief desc here'}
        expose :address, documentation: {type: String, desc: 'brief desc here'}
        expose :blurb, documentation: {type: String, desc: 'brief desc here'}
        expose :city, documentation: {type: String, desc: 'brief desc here'}
        expose :facebook, documentation: {type: String, desc: 'brief desc here'}
        expose :image, documentation: {type: String, desc: 'brief desc here'}
        expose :lat, documentation: {type: String, desc: 'brief desc here'}
        expose :lon, documentation: {type: String, desc: 'brief desc here'}
        expose :location, documentation: {type: String, desc: 'brief desc here'}
        expose :name, documentation: {type: String, desc: 'brief desc here'}
        expose :score, documentation: {type: String, desc: 'brief desc here'}
        expose :slug, documentation: {type: String, desc: 'brief desc here'}
        expose :state, documentation: {type: String, desc: 'brief desc here'}
        expose :twitter, documentation: {type: String, desc: 'brief desc here'}
        expose :website, documentation: {type: String, desc: 'brief desc here'}

         # expose :web_description, documentation: {type: String, desc: 'brief desc here'}

        # with_options(format_with: :iso_timestamp) do
        #   expose :created_at
        #   expose :updated_at
        # end

        private

        def url
          v1_venues_path(id: object.id)
        end

      end
    end
  end
end
