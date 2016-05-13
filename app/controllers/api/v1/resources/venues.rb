# frozen_string_literal: true
module API
  module V1
    module Resources
      class Venues < API::V1::Root
        resources :venues, desc: 'Operation related to Venues' do
          desc 'Get all interests' do
            success API::V1::Entities::Venue
          end
          get do
            present paginate(Venue.all), with: API::V1::Entities::Venue
          end
        end
      end
    end
  end
end
