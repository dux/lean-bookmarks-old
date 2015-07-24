#config.ru
require 'rubygems'
require 'bundler'

Bundler.require

set :root, Pathname(__FILE__).dirname
set :run, false

ENV['RAKE_ENV'] = 'production'
set :environment, ENV['RAKE_ENV'].to_s.index('prod') ? :production : :development

require './app/main'

run Sinatra::Application
