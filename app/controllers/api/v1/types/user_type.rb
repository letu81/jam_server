# frozen_string_literal: true
module API
  module V1
    module Types
      class UserType
        attr_reader :value

        def initialize(value)
          @value = value
        end

        def self.parse(value)
          raise 'Invalid user type, it needs to be either consumer or food_truck' unless %w(consumer or food_truck).include?(value)
          new(value.capitalize)
        end

        def self.desc
          'User type, it can be either consumer or food_truck.'
        end

        def to_s
          value
        end
      end
    end
  end
end
