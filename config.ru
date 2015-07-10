#config.ru
require 'rubygems'
require 'bundler'

Bundler.require

require './router'

set :root, Pathname(__FILE__).dirname
# set :environment, :production
set :environment, ENV['RAKE_ENV'].to_s.index('prod') ? :production : :development
set :run, false
run Sinatra::Application
