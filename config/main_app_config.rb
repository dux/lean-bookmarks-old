set :static_cache_control, [:public, {:max_age => 30.days }]
set :show_exceptions, true
set :raise_errors, true
set :protection, true

use Rack::Session::Cookie, :key => 'lux.session', :path => '/', :expire_after => 1.month, :secret => 'b1e4f4cf45ffe47efb0c70ac64397e36'
use BetterErrors::Middleware; BetterErrors.application_root = __dir__

before do
  @path = request.path.split('/')
  @path.shift
  @root_part = @path[0] ? @path.shift : nil
  @first_part = @path[0]
  
  Thread.current[:lux] = {}
  Thread.current[:lux][:sinatra] = self

  if session[:u_id]
    User.current = User.find(session[:u_id])
  end
end

after do
  if Hash === response.body
    content_type :json
    ret = JSON.generate(response.body)
    ret = "#{params[:callback]}(#{ret})" if params[:callback]
    body ret
  else
    content_type('text/plain') unless response.body[0].to_s[0,1] == '<'
  end
end
