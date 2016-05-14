# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'pg'
gem 'puma'

# api
gem 'grape', '0.14.0'
gem 'grape-middleware-logger'
gem 'grape-route-helpers'
gem 'grape-entity'
gem 'kramdown'
gem 'rack-cors', require: 'rack/cors'
gem 'httparty'
gem 'kaminari'

# Authentication
gem 'doorkeeper'
gem 'wine_bouncer'
gem 'bcrypt'
gem 'hashie-forbidden_attributes'
gem 'oauth2'

# documentation
gem 'grape-swagger'
gem 'grape-swagger-rails'

gem 'usecasing'

# JS
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# TODO for later
# instrumentation
# gem 'raygun4ruby'
# gem 'newrelic_rpm'


group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'shoulda-matchers', require: false
  gem 'factory_girl_rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'faker'
end