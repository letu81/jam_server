# frozen_string_literal: true
module API
  module V1
    module Entities
      class TruckEvent < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :city, documentation: {type: String, desc: 'brief desc here'}
        expose :date_date, documentation: {type: String, desc: 'brief desc here'}
        expose :day_of_week, documentation: {type: String, desc: 'brief desc here'}
        expose :dateMD, documentation: {type: String, desc: 'brief desc here'}
        expose :description, documentation: {type: String, desc: 'brief desc here'}
        expose :end_time, documentation: {type: String, desc: 'brief desc here'}
        expose :end_time_text, documentation: {type: String, desc: 'brief desc here'}
        expose :event, documentation: {type: String, desc: 'brief desc here'}
        expose :hashtag, documentation: {type: String, desc: 'brief desc here'}
        expose :hasFree, documentation: {type: String, desc: 'brief desc here'}
        expose :hasEvent, documentation: {type: String, desc: 'brief desc here'}
        expose :hasSpecial, documentation: {type: String, desc: 'brief desc here'}
        expose :image, documentation: {type: String, desc: 'brief desc here'}
        expose :isFeatured, documentation: {type: String, desc: 'brief desc here'}
        expose :landmark, documentation: {type: String, desc: 'brief desc here'}
        expose :latitude, documentation: {type: String, desc: 'brief desc here'}
        expose :location, documentation: {type: String, desc: 'brief desc here'}
        expose :longitude, documentation: {type: String, desc: 'brief desc here'}
        expose :metro, documentation: {type: String, desc: 'brief desc here'}
        expose :neighborhood, documentation: {type: String, desc: 'brief desc here'}
        expose :neighborhood_id, documentation: {type: String, desc: 'brief desc here'}
        expose :slug, documentation: {type: String, desc: 'brief desc here'}
        expose :start_time, documentation: {type: String, desc: 'brief desc here'}
        expose :start_time_text, documentation: {type: String, desc: 'brief desc here'}
        expose :state, documentation: {type: String, desc: 'brief desc here'}
        expose :truck_name, documentation: {type: String, desc: 'brief desc here'}
        expose :vendor_id, documentation: {type: String, desc: 'brief desc here'}

        # with_options(format_with: :iso_timestamp) do
        #   expose :created_at
        #   expose :updated_at
        # end

        private

        def url
          v1_truck_events_path(id: object.id)
        end

      end
    end
  end
end
