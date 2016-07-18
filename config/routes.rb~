Rails.application.routes.draw do
  use_doorkeeper
  mount API::Base => '/'

  mount GrapeSwaggerRails::Engine => '/docs'
end
