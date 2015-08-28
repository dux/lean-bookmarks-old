require 'cgi'

class PromoTest < LuxTest

  def initialize(opts={})
    @opts = opts
  end

  def run!

    test 'Home page' do
      data = http_get '/'
      assert_exists data, 'is simple service for organizing'
    end

    test 'Login page present' do
      data = http_get '/login'
      assert_exists data, '/api/users/login'
    end

  end

end