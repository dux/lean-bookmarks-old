require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/json"
require 'json'
require 'active_record'
require 'colorize'
require './lux/init'

set :static_cache_control, [:public, {:max_age => 30.days }]

configure :production do
  Lux.in_production = production? ? true : false
end

before do
  @path = request.path.split('/')
  @path.shift
  
  User.request = request
  Lux.sinatra = self
  # Lux.in_production = ENV['RACK_ENV'] == 'production' ? true : false
end

get '*' do
  return Template.with_layout('main/index') unless @path[0]

  case @path.shift.singularize.to_sym
    when :user
      return Main::UserApp.router(*@path)

    when :api
      return MasterApi.render_root unless @path[0]
      json MasterApi.exec(@path) 

    else
      'Unknown'
  end
end
