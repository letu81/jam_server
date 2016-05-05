# frozen_string_literal: true
module API
  class Dispatch < Grape::API
    format :json
    use Grape::Middleware::Logger

    mount API::V1::Root
  end

  Base = Rack::Builder.new do
    run API::Dispatch
  end
end
