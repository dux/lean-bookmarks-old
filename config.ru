#config.ru
require 'rubygems'
require 'bundler'

Bundler.require

require 'rack/protection'

require './lux'

set :root, Pathname(__FILE__).dirname
set :environment, :production
set :run, false
run Sinatra::Application
