# frozen_string_literal: true
module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        helpers do
          def current_user
            resource_owner
          end

          def present_model(model, with:)
            if model.valid?
              present model, with: with
            else
              error!({ message: 'Validation error', errors: model.errors.full_messages }, 422)
            end
          end
        end
      end

      def auth_header(description)
        {
            Authorization: {
                description: description,
                required: true
            }
        }
      end

      def auth_headers
        auth_header('The authorization token.')
      end

      def client_auth_headers
        auth_header('The client authorization token.')
      end

      module_function :auth_headers, :client_auth_headers, :auth_header
    end
  end
end
