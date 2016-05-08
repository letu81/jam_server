# frozen_string_literal: true
module API
  module V1
    module Resources
      class Events < API::V1::Root
        resources :events, desc: 'Operation related to Events' do
          desc 'Get all interests' do
            success API::V1::Entities::Event
          end
          get do
            present Event.all, with: API::V1::Entities::Event
          end
        end
      end
    end
  end
end
