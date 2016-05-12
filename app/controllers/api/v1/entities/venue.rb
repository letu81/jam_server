# frozen_string_literal: true
module API
  module V1
    module Entities
      class Venue < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :venue_id, documentation: {type: String, desc: 'unique id auto-generated from ticketfly or form'}
        expose :added_manually, documentation: {type: String, desc: 'if venue is added by user'}
        expose :address, documentation: {type: String, desc: 'street address'}
        expose :blurb, documentation: {type: String, desc: 'brief description of venue'}
        expose :city, documentation: {type: String, desc: ''}
        expose :facebook, documentation: {type: String, desc: 'venue facebook url'}
        expose :image, documentation: {type: String, desc: 'image of venue'}
        expose :lat, documentation: {type: String, desc: 'latitude'}
        expose :lon, documentation: {type: String, desc: 'longitude'}
        expose :location, documentation: {type: String, desc: 'location (ex: 9th & V)'}
        expose :name, documentation: {type: String, desc: 'venue name'}
        expose :score, documentation: {type: String, desc: 'venue popularity score'}
        expose :slug, documentation: {type: String, desc: ''}
        expose :state, documentation: {type: String, desc: 'DC MD or VA'}
        expose :twitter, documentation: {type: String, desc: 'venue twitter url'}
        expose :website, documentation: {type: String, desc: 'venue website url'}

        private

        def url
          v1_venues_path(id: object.id)
        end

      end
    end
  end
end
