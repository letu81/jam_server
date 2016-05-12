# frozen_string_literal: true
module API
  module V1
    module Resources
      class TruckVendors < API::V1::Root
        resources :truck_vendors, desc: 'Operation related to Truck Vendors' do
          desc 'Get all interests' do
            success API::V1::Entities::TruckVendor
          end
          get do
            present TruckVendor.all, with: API::V1::Entities::TruckVendor
          end
        end
      end
    end
  end
end
