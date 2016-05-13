# thedistrict.in REST-like API v2

### rails 4.2.6
### ruby 2.3.0

To get started

* Fork/Clone

* bundle install

* bundle exec rake db:migrate

* bundle exec rake fetch:events

* rails s

#### Noteworthy Gems
[Full Gemfile](https://github.com/mcrundo/district_grape/blob/master/Gemfile)

[Grape](https://github.com/ruby-grape/grape) - An opinionated framework for creating REST-like APIs in Ruby

[grape-swagger](https://github.com/ruby-grape/grape-swagger) - API Docs 

[rack-cors](https://github.com/cyu/rack-cors) - Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.

[wine_bouncer](https://github.com/antek-drzewiecki/wine_bouncer) - A Ruby gem that allows Oauth2 protection with Doorkeeper for Grape Api's

[doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) - Doorkeeper is an OAuth 2 provider for Rails

[hashie-forbidden_attributes](https://github.com/Maxim-Filimonov/hashie-forbidden_attributes) - Hashie compatibility layer for forbidden attributes protection

[kramdown](https://rubygems.org/gems/kramdown/versions/1.10.0) - markdown parser

[puma](https://rubygems.org/gems/puma/versions/3.4.0) - HTTP 1.1 server for Ruby/Rack applications


## Access the API

docs 

[thedistrictin-api.herokuapp.com/docs](http://thedistrictin-api.herokuapp.com/docs)

[localhost:3000/docs](http://localhost:3000/docs)

#### endpoints

[/events](https://thedistrictin-api.herokuapp.com/v1/events)

[/venues](https://thedistrictin-api.herokuapp.com/v1/venues)

![theDistrictNetwork](http://i.imgur.com/zuo0jYu.png)
