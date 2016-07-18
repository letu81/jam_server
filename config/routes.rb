Rails.application.routes.draw do
  devise_for :users
  use_doorkeeper
  mount API::Base => 'api/'

  mount GrapeSwaggerRails::Engine => '/docs'
end
