# frozen_string_literal: true
module API
  module V1
    module Entities
      class Event < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

         expose :event_id, documentation: {type: String, desc: 'brief desc here'}
         expose :venue_id, documentation: {type: String, desc: 'brief desc here'}
         expose :image, documentation: {type: String, desc: 'brief desc here'}
         expose :category, documentation: {type: String, desc: 'brief desc here'}
         expose :sub_category, documentation: {type: String, desc: 'brief desc here'}
         expose :score, documentation: {type: String, desc: 'brief desc here'}
         expose :seatgeek_url, documentation: {type: String, desc: 'brief desc here'}
         expose :title, documentation: {type: String, desc: 'brief desc here'}
         expose :short_title, documentation: {type: String, desc: 'brief desc here'}
         expose :date_tbd, documentation: {type: String, desc: 'brief desc here'}
         expose :time_tbd, documentation: {type: String, desc: 'brief desc here'}
         expose :datetime_local, documentation: {type: String, desc: 'brief desc here'}
         expose :added_manually, documentation: {type: String, desc: 'brief desc here'}
         expose :youtube, documentation: {type: String, desc: 'brief desc here'}
         expose :facebook, documentation: {type: String, desc: 'brief desc here'}
         expose :twitter, documentation: {type: String, desc: 'brief desc here'}
         expose :spotify, documentation: {type: String, desc: 'brief desc here'}
         expose :soundcloud, documentation: {type: String, desc: 'brief desc here'}
         expose :hashtag, documentation: {type: String, desc: 'brief desc here'}
         expose :date, documentation: {type: String, desc: 'brief desc here'}
         expose :isFree, documentation: {type: String, desc: 'brief desc here'}
         expose :venue_name, documentation: {type: String, desc: 'brief desc here'}
         expose :city, documentation: {type: String, desc: 'brief desc here'}
         expose :state, documentation: {type: String, desc: 'brief desc here'}
         expose :day, documentation: {type: String, desc: 'brief desc here'}
         expose :announce_date, documentation: {type: String, desc: 'brief desc here'}
         expose :date_date, documentation: {type: String, desc: 'brief desc here'}
         expose :isFeatured, documentation: {type: String, desc: 'brief desc here'}
         expose :age_limit, documentation: {type: String, desc: 'brief desc here'}
         expose :price, documentation: {type: String, desc: 'brief desc here'}
         expose :time, documentation: {type: String, desc: 'brief desc here'}
         expose :description, documentation: {type: String, desc: 'brief desc here'}
         expose :slug, documentation: {type: String, desc: 'brief desc here'}
         expose :eventStatus, documentation: {type: String, desc: 'brief desc here'}
         expose :address, documentation: {type: String, desc: 'brief desc here'}
         expose :event_blurb, documentation: {type: String, desc: 'brief desc here'}
         expose :venue_blurb, documentation: {type: String, desc: 'brief desc here'}
         expose :web_description, documentation: {type: String, desc: 'brief desc here'}

        # with_options(format_with: :iso_timestamp) do
        #   expose :created_at
        #   expose :updated_at
        # end

        private

        def url
          v1_events_path(id: object.id)
        end

      end
    end
  end
end
