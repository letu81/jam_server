# frozen_string_literal: true
module Users
  module Create
    class Base < UseCase::Base
      depends CreateUser, Me::Update::UpdateAttributes
    end
  end
end
