set :static_cache_control, [:public, {:max_age => 30.days }]
set :protection, true
set :show_exceptions, true
set :raise_errors, true

use Rack::Session::Cookie, :key => 'lux.session', :path => '/', :expire_after => 1.month, :secret=>Digest::MD5.hexdigest(__FILE__)

if Page.dev?
  use BetterErrors::Middleware; BetterErrors.application_root = __dir__.sub('/config','')
end

def get
  "LUX is running!\n\nNow define get() and return some data"
end

before do
  @page_render_start = Time.now
  Page.init(self)

  path = request.path.split(':', 2)
  if path[1]
    @namespace = path[1]
    Page.params[:suffix] = @namespace
  end
  @path = path[0].split('/')
  @path.shift
  @root = @path[0] ? @path.shift.gsub('-','_').to_sym : nil

  @path[0] = StringBase.decode(@path[0]) rescue @path[0] if @path[0]
end

get '*' do
  get
end

post '*' do
  post
end

after do
  puts "- #{Page.request.path} rendered in #{((Time.now-@page_render_start)*1000).to_i} ms".yellow if Page.dev?

  body Page.body

  if Page.body
    body Page.body    
  else
    test_body = response.body.kind_of?(Array) && !response.body[1] ? response.body[0] : response.body

    if test_body.kind_of?(String)
      content_type('text/plain') unless test_body[0,1] == '<'
    elsif test_body.kind_of?(Hash)
      content_type :json
      ret = Page.dev? ? JSON.pretty_generate(response.body) : JSON.generate(response.body)
      ret = "#{params[:callback]}(#{ret})" if params[:callback]
      body "#{ret}\n"
    end
  end
end

lux_smart_require './config/config_loader'