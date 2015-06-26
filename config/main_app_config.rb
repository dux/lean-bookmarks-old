set :static_cache_control, [:public, {:max_age => 30.days }]
set :show_exceptions, true
set :raise_errors, true
set :protection, true

use Rack::Session::Cookie, :key => 'lux.session', :path => '/', :expire_after => 1.month, :secret => 'b1e4f4cf45ffe47efb0c70ac64397e36'
use BetterErrors::Middleware; BetterErrors.application_root = __dir__

before do
  Lux.init(self)

  if Lux.dev? && params[:usrid]
    session[:u_id] = params[:usrid].to_i
  end

  path = request.path.split(':', 2)
  if path[1]
    @path_suffix = path[1]
    Lux.params[:suffix] = @path_suffix
  end
  @path = path[0].split('/')
  @path.shift
  @root_part = @path[0] ? @path.shift.gsub('-','_').singularize.to_sym : nil
  @first_part = @path[0]

  # load user if there is session string
  if session[:u_id]
    begin
      User.current = User.find(session[:u_id])
    rescue
      session.delete(:u_id)
    end
  end

  @path[0] = StringBase.decode(@path[0]) rescue @path[0] if @path[0]
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
