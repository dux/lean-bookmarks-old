require 'cgi'

class PromoTest < LuxTest

  def initialize(opts={})
    @opts = opts
  end

  def run!

    test 'Home page' do
      exists 'is simple service for organizing', http_get('/')
    end

    test 'Login page present' do
      exists '/api/users/login', http_get('/login')
    end

    test 'User login' do
      error 'users/login', :email=>'rejotl@gmail.com', :pass=>'drx'
      ok    'users/login', :email=>'rejotl@gmail.com', :pass=>'dr'
    end

  end

end