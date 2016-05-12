# frozen_string_literal: true
module API
  module V1
    module Entities
      class Event < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

         expose :event_id, documentation: {type: String, desc: 'unique id of event'}
         expose :venue_id, documentation: {type: String, desc: 'id of venue. used to link to venue from event.'}
         expose :image, documentation: {type: String, desc: 'picture of event.'}
         expose :category, documentation: {type: String, desc: 'category of event (ex: Concert)'}
         expose :sub_category, documentation: {type: String, desc: 'subcategory of event (ex: Indie Rock)'}
         expose :score, documentation: {type: String, desc: 'popularity score of event'}
         expose :seatgeek_url, documentation: {type: String, desc: 'url to buy tickets or webpage of event'}
         expose :title, documentation: {type: String, desc: 'event title'}
         expose :short_title, documentation: {type: String, desc: 'event title truncated'}
         expose :date_tbd, documentation: {type: String, desc: 'if event date is unkown'}
         expose :time_tbd, documentation: {type: String, desc: 'if event time is unkown'}
         expose :datetime_local, documentation: {type: String, desc: 'event in datetime format'}
         expose :added_manually, documentation: {type: String, desc: 'if event is user added'}
         expose :youtube, documentation: {type: String, desc: 'iframe for event detail'}
         expose :facebook, documentation: {type: String, desc: 'event facebook full url'}
         expose :twitter, documentation: {type: String, desc: 'event twitter full url'}
         expose :spotify, documentation: {type: String, desc: 'event performer spotify url'}
         expose :soundcloud, documentation: {type: String, desc: 'event performer soundcloud'}
         expose :hashtag, documentation: {type: String, desc: ''}
         expose :date, documentation: {type: String, desc: 'event date as string format'}
         expose :isFree, documentation: {type: String, desc: 'if event is free. bool.'}
         expose :venue_name, documentation: {type: String, desc: ''}
         expose :city, documentation: {type: String, desc: ''}
         expose :state, documentation: {type: String, desc: 'DC MD or VA'}
         expose :day, documentation: {type: String, desc: 'event day of week'}
         expose :announce_date, documentation: {type: String, desc: 'date event was announced'}
         expose :date_date, documentation: {type: String, desc: 'event date as date format'}
         expose :isFeatured, documentation: {type: String, desc: 'if event is featured. bool.'}
         expose :age_limit, documentation: {type: String, desc: 'if event has age limit (ex: 21+)'}
         expose :price, documentation: {type: String, desc: 'event price as string (ex: $25)'}
         expose :time, documentation: {type: String, desc: 'event time in 12h format'}
         expose :description, documentation: {type: String, desc: 'longtext description of event. html is removed.'}
         expose :slug, documentation: {type: String, desc: ''}
         expose :eventStatus, documentation: {type: String, desc: 'if event is active or sold out'}
         expose :address, documentation: {type: String, desc: 'address with city, state, and zip'}
         expose :event_blurb, documentation: {type: String, desc: 'short description of event'}
         expose :venue_blurb, documentation: {type: String, desc: 'short description of venue'}
         expose :web_description, documentation: {type: String, desc: 'longtext description of event. html encoded.'}

        private

        def url
          v1_events_path(id: object.id)
        end

      end
    end
  end
end
