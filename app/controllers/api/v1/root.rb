# frozen_string_literal: true
module API
  module V1
    class Root < API::Dispatch
      include API::V1::Defaults

      version 'v1'
      use ::WineBouncer::OAuth2

      module JsonErrorFormatter
        def self.call(message, _backtrace, _options, _env)
          {
              message: message[:message],
              errors: message[:errors]
          }.to_json
        end
      end

      error_formatter :json, JsonErrorFormatter

      rescue_from :all do |e|
        eclass = e.class.to_s
        message = "OAuth error: #{e}" if eclass =~ /WineBouncer::Errors/
        status = case
                   when eclass.match('OAuthUnauthorizedError')
                     401
                   when eclass.match('OAuthForbiddenError')
                     403
                   when eclass.match('RecordNotFound'), e.message.match(/unable to find/i).present?
                     404
                   when eclass.match('Grape::Exceptions::ValidationErrors')
                     400
                   else
                     raise e if Rails.env.test?
                     (e.respond_to? :status) && e.status || 500
                 end
        opts = { error: (message || e.message).to_s }
        opts[:trace] = e.backtrace[0, 10] unless Rails.env.production?
        Rack::Response.new(opts.to_json, status, 'Content-Type' => 'application/json',
                                                  'Access-Control-Allow-Origin' => '*',
                                                  'Access-Control-Request-Method' => '*').finish
      end

      mount API::V1::Resources::Categories
      mount API::V1::Resources::Devices
      mount API::V1::Resources::Locks
      mount API::V1::Resources::Me
      mount API::V1::Resources::Messages
      mount API::V1::Resources::Products
      mount API::V1::Resources::Locksmiths
      mount API::V1::Resources::Users
      mount API::V1::Resources::Versions
      mount API::V1::Resources::JamServices
      mount API::V1::Resources::Feedback

      desc 'Alive endpoint', hidden: true
      resource :ping do
        get do
          'pong'
        end
      end

      add_swagger_documentation(
          api_version: 'v1',
          mount_path: 'doc',
          hide_documentation_path: true,
          hide_format: true,
          #markdown: GrapeSwagger::Markdown::KramdownAdapter.new,
          info: {
              title: 'jam smarthome API',
              description: 'The smarthome API of jiaanmei.com'
          }
      )
    end
  end
end
