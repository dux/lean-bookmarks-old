set :static_cache_control, [:public, {:max_age => 30.days }]
set :show_exceptions, true
set :raise_errors, true
set :protection, true

use Rack::Session::Cookie, :key => 'lux.session', :path => '/', :expire_after => 1.month, :secret=>Digest::MD5.hexdigest(__FILE__)
use BetterErrors::Middleware; BetterErrors.application_root = __dir__.sub('/config','')

def get
  "LUX is running!\n\nNow define get() and return some data"
end

before do
  Lux.init(self)

  path = request.path.split(':', 2)
  if path[1]
    @path_suffix = path[1]
    Lux.params[:suffix] = @path_suffix
  end
  @path = path[0].split('/')
  @path.shift
  @root_part = @path[0] ? @path.shift.gsub('-','_').singularize.to_sym : nil
  @first_part = @path[0]

  @path[0] = StringBase.decode(@path[0]) rescue @path[0] if @path[0]
end

get '*' do
  body get
end

post '*' do
  body post
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

