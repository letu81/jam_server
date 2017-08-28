# frozen_string_literal: true
source 'https://gems.ruby-china.org'

ruby '2.4.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.6'
#gem 'pg', '0.18.1'
gem 'mysql2', '0.3.20'
gem 'puma'

gem 'devise', '4.1.1'
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'settingslogic', '~> 2.0.9'

# api
gem 'grape', '~> 0.18.0'
gem 'grape-middleware-logger', '1.6.0'
gem 'grape-route-helpers', '1.2.2'
gem 'grape-entity', '0.5.1'
gem 'kramdown'
gem 'rack-cors', require: 'rack/cors'
gem 'httparty'
gem 'kaminari', '0.16.3', require: 'kaminari/grape'

# Authentication
gem 'doorkeeper'
gem 'wine_bouncer'
gem 'bcrypt'
gem 'hashie-forbidden_attributes'
gem 'oauth2'

# documentation
gem 'grape-swagger', '0.20.3'
gem 'grape-swagger-rails', '0.2.0'

gem 'usecasing'

gem 'migration_comments'
gem 'mini_magick'

gem 'resque', '~> 1.27.0'

# JS
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# Enums
gem 'enumerate_it', '1.3.0'

# RabbitMQ
gem 'bunny', '2.4.0'

# Colored logging
gem 'shog', '0.1.8'

gem 'whenever', :require => false

gem 'jpush', '4.0.8', git: 'https://github.com/jpush/jpush-api-ruby-client.git'

gem 'chinese_pinyin'
gem 'GB2260'
gem 'geocoder'

gem 'agent'

gem 'axlsx'

# TODO for later
# instrumentation
# gem 'raygun4ruby'
# gem 'newrelic_rpm'


group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'shoulda-matchers', require: false
  gem 'nokogiri', '1.6.8'
  gem 'factory_girl_rails', '4.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'faker'
end
