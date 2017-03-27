require 'resque/server'
Rails.application.routes.draw do
  devise_for :users
  use_doorkeeper
  mount API::Base => 'api/'

  root 'home#index'
  get 'wap' => 'wap#index'

  mount GrapeSwaggerRails::Engine => '/docs'

  mount Resque::Server, at: '/jobs'
end