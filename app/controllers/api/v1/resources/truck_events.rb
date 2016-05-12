# frozen_string_literal: true
module API
  module V1
    module Resources
      class TruckEvents < API::V1::Root
        resources :truck_events, desc: 'Operation related to Truck Events' do
          desc 'Get all interests' do
            success API::V1::Entities::TruckEvent
          end
          get do
            present TruckEvent.all, with: API::V1::Entities::TruckEvent
          end
        end
      end
    end
  end
end
