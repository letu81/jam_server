# frozen_string_literal: true
module API
  module V1
    module Entities
      class TruckVendor < Grape::Entity
        include GrapeRouteHelpers::NamedRouteMatcher

        format_with(:iso_timestamp, &:iso8601)

        expose :description, documentation: {type: String, desc: 'truck vendor description'}
        expose :facebook, documentation: {type: String, desc: 'truck facebook full url'}
        expose :hashtag, documentation: {type: String, desc: 'truck hashtag custom field'}
        expose :image, documentation: {type: String, desc: 'image of truck'}
        expose :instagram, documentation: {type: String, desc: 'truck vendor instagram full url'}
        expose :logo, documentation: {type: String, desc: 'truck logo'}
        expose :menu, documentation: {type: String, desc: 'truck menu longtext'}
        expose :name, documentation: {type: String, desc: 'truck name'}
        expose :performance_score, documentation: {type: String, desc: 'user rating of truck'}
        expose :phone_number, documentation: {type: String, desc: 'truck phone number'}
        expose :price_score, documentation: {type: String, desc: 'user rating of price point'}
        expose :primary_category, documentation: {type: String, desc: 'primary category or cuisine of food (ie: American)'}
        expose :secondary_category, documentation: {type: String, desc: 'specialty cuisine (ie: Burgers)'}
        expose :slug, documentation: {type: String, desc: 'url slug'}
        expose :twitter, documentation: {type: String, desc: 'truck twitter full url'}
        expose :url, documentation: {type: String, desc: 'website url'}
        expose :contact_name, documentation: {type: String, desc: 'truck contact name'}
        expose :contact_email, documentation: {type: String, desc: 'truck contact email'}
        expose :contact_phone, documentation: {type: String, desc: 'truck contact phone number'}
        expose :isFeatured, documentation: {type: String, desc: 'truck is featured'}

        private

        def url
          v1_truck_vendors_path(id: object.id)
        end

      end
    end
  end
end
