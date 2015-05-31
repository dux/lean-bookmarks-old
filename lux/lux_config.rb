set :static_cache_control, [:public, {:max_age => 30.days }]
use Rack::Session::Cookie, :key => 'lux.session', :path => '/', :expire_after => 1.month, :secret => 'b1e4f4cf45ffe47efb0c70ac64397e36'

before do
  @path = request.path.split('/')
  @path.shift
  @root_part = @path[0] ? @path.shift.singularize.to_sym : nil
  
  User.request = request
  Lux.sinatra = self
end

after do
  if Hash === response.body
    content_type :json
    ret = JSON.generate(response.body)
    ret = "#{params[:callback]}(#{ret})" if params[:callback]
    body ret
  else
    content_type('text/plain') unless response.body[0][0,1] == '<'
  end  
end
