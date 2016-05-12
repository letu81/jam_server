# frozen_string_literal: true
module API
  module V1
    module Entities
      class TruckEvent < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :city, documentation: {type: String, desc: ''}
        expose :date_date, documentation: {type: String, desc: 'date formatted'}
        expose :day_of_week, documentation: {type: String, desc: 'day of week'}
        expose :dateMD, documentation: {type: String, desc: 'date'}
        expose :description, documentation: {type: String, desc: 'truck description'}
        expose :end_time, documentation: {type: String, desc: 'end time in time format'}
        expose :end_time_text, documentation: {type: String, desc: 'end time as string'}
        expose :event, documentation: {type: String, desc: 'event hosting food truck (ex: Truckaroo)'}
        expose :hashtag, documentation: {type: String, desc: ''}
        expose :hasFree, documentation: {type: String, desc: 'truck has a free item. bool.'}
        expose :hasEvent, documentation: {type: String, desc: 'truck event is at an event. bool.'}
        expose :hasSpecial, documentation: {type: String, desc: 'truck has a special. bool.'}
        expose :image, documentation: {type: String, desc: 'image of truck at truck event'}
        expose :isFeatured, documentation: {type: String, desc: 'truck is featured. bool.'}
        expose :landmark, documentation: {type: String, desc: 'landmark near truck event'}
        expose :latitude, documentation: {type: String, desc: 'lat'}
        expose :location, documentation: {type: String, desc: 'location of truck (ex: 16th & K)'}
        expose :longitude, documentation: {type: String, desc: 'lon'}
        expose :metro, documentation: {type: String, desc: 'nearest metro station'}
        expose :neighborhood, documentation: {type: String, desc: 'nearest neighborhood'}
        expose :neighborhood_id, documentation: {type: String, desc: 'id of neighborhood'}
        expose :slug, documentation: {type: String, desc: ''}
        expose :start_time, documentation: {type: String, desc: 'start time in time format'}
        expose :start_time_text, documentation: {type: String, desc: 'start time as string'}
        expose :state, documentation: {type: String, desc: 'DC MD or VA'}
        expose :truck_name, documentation: {type: String, desc: 'truck name from truck_vendor'}
        expose :vendor_id, documentation: {type: String, desc: 'vendor id from truck_vendor'}

        private

        def url
          v1_truck_events_path(id: object.id)
        end

      end
    end
  end
end
