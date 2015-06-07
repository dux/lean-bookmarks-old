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
  
  Thread.current[:lux] = {}
  Thread.current[:lux][:request] = request
  Thread.current[:lux][:sinatra] = self

  @body = LuxRenderCell.debug if Lux.dev? && @root_part == 'debug'
end

after do
  Thread.current[:lux] = nil

  if Hash === response.body
    content_type :json
    ret = JSON.generate(response.body)
    ret = "#{params[:callback]}(#{ret})" if params[:callback]
    body ret
  else
    content_type('text/plain') unless response.body[0].to_s[0,1] == '<'
  end  
end


 