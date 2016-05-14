# frozen_string_literal: true
module Users
  module Create
    class CreateUser < UseCase::Base
      def perform
        context.user = User.create(create_params)
        stop! unless context.user.valid?
      end


      def create_params
        context
          .to_hash
          .merge(confirmation_token: SecureRandom.uuid.to_s)
          .merge(confirmation_token_sent_at: Time.zone.now)
          .merge(password_set: true)
          .slice(:email, :password)
      end
    end
  end
end
