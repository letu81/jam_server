# frozen_string_literal: true
module Me
  module Update
    class UpdateAttributes < UseCase::Base
      attr_reader :user

      def before
        @user = context.user
      end

      def perform
        attribute_keys = %i(first_name last_name type phone_number )
        attributes = context.to_hash.slice(*attribute_keys)
        parse_address_attributes(attributes, context.address)
        user.update(attributes)
      end

      private

      def parse_address_attributes(attributes, address)
        return if address.nil? || address.empty?

        attributes[:address_line_1] = address['line1'] if address.key?('line1')
        attributes[:address_line_2] = address['line2'] if address.key?('line2')

        [:city, :state, :zipcode].each do |key|
          key_string = key.to_s
          attributes[key] = address[key_string] if address.key?(key_string)
        end
      end
    end
  end
end
