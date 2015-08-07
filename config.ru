require 'rubygems'
require 'bundler'

Bundler.require

require "sinatra/reloader" unless ENV['RACK_ENV'].to_s.index('prod')

set :root, Dir.pwd
set :run, false

# ENV['RACK_ENV'] = 'production'
# set :environment, ENV['RACK_ENV'].to_s.index('prod') ? :production : :development

require './app/main'

run Sinatra::Application
