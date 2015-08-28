require './lux_test'
require './promo_test'

LuxTest.new( :url=>'http://localhost:3000' ).run! do
  PromoTest.new( :user=>3 ).run!
  # SessionTest.new( :email=>'jozo@bozo1.com' ).run!
  # MeetingTest.new( :user=>3 ).run! # put user if 100000 for error
end