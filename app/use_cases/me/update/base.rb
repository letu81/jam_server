# frozen_string_literal: true
module Me
  module Update
    class Base < UseCase::Base
      depends UpdateAttributes
    end
  end
end
