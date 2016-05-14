# thedistrict.in REST-like API v2

Rails-Grape REST-like API for theDistrict.in.
=============================================================
# thedistrict.in REST-like API v1

### rails 4.2.6
### ruby 2.3.0

To get started

* Fork/Clone

* bundle install

* bundle exec rake db:migrate

* bundle exec rake fetch:events

* Visit http://localhost:3000/docs to see the swagger interface
  * sidenote: the protocol is being submitted incorrectly if you're running local. It attempts to hit https instead of http and is causing a CORS issue. The quick and dirty way around this is to run your server through a tunnel such as [ngrok](https://ngrok.com/) which will give you a domain that points at localhost but masks as an https/http live domain.

* Visit http://localhost:3000/v1/events to see an example of what the response would be

##Purpose
The purpose of this document is to ensure all members of the api team follow best practices.

Read the [general guidelines](https://github.com/Patron-team/guide) beforehand as this contains only project specific stuff.

##Prelude
> The only way to go fast is to go well.<br>
> Vehement Mediocrity - Robert C. Martin (Uncle Bob)

# Table of Contents

[1. Frameworks and tech](#frameworks-and-tech)

[2. Getting started](#getting-started)

[3. Coding styles](#coding-styles)

[4. Coding practices](#coding-practices)

[5. Deploy](#deploy)

[6. Additional resources](#additionl-resources)

#Frameworks and tech

 + Postgres
 + Rails
 + Grape
 + Rspec

#Getting started

  So you cloned the repo and are on the master branch:

  + Install the requiered version of ruby, see `.ruby-version` for the current version used
  + `bundle install` your gems, is recommended you use [rvm](https://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv) to manage gems ond rubies
  + create the database `bundle exec rake db:create`
  + create the database `bundle exec rake db:migrate`
  + prepare test database `bundle exec rake db:test:prepare`
  + bundle exec rake fetch:events
  + bundle exec rake fetch:venues
  + `rails s` to start the api and navigate in your browser to `localhost:3000/docs` for the interactive documentation


  You should be ready to develop, remember the __Making changes__ section of the General guidelines.
  Read the rest of this document before writing your first lines of code

#Coding styles

  Coding styles are defined [here](https://github.com/bbatsov/ruby-style-guide) we customize them via `.rubocop.yml`.


  Follow codding styles for rspec described [here](http://betterspecs.org/).


  You can check your code continuously by using `guard` or do one time check via `rubocop`

#Coding practices

  This is a very brod topic but the essential topics are:

  + always write tests
  + be on the look out for [code smells](http://blog.codinghorror.com/code-smells)
  + Apply the boy scout rule, always leave the code cleaner than you found it

#Deploy

  For now we use Heroku to deploy.

  + Create a free account if you don't already have one [here](https://signup.heroku.com).
  + Install Heroku Toolbelt [here](https://toolbelt.heroku.com/), and log in via `heroku login` using your Heroku credentials.
  + Create an app named `(your-name)-patron-backend`
  + Connect your private repository to Heroku. [Help!](https://devcenter.heroku.com/articles/github-integration)

#Additional resources

  + [Swagger](http://swagger.io/)
=======
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
