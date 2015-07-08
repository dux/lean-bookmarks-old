class Lux
  @@irregulars = {}

  def self.try(name)
    begin
      yield
    rescue
      Lux.report_error_html($!, name)
    end
  end  

  def self.root
    __FILE__.sub('/lux/modules/lux.rb','')
  end

  def self.report_error_html(o, name=nil)
    trace = o.backtrace.select{ |el| el.index('/app/') }.map{ |el| el.split('/app/', 2)[1] }.map{ |el| "- #{el}" }.join("\n")
    msg   = o.message.gsub('","',%[",\n "])
    return %[<pre style="color:red; background:#eee; padding:10px; font-family:'Lucida Console'; line-height:14pt; font-size:10pt;">#{name || 'Undefined name'}\nError: #{msg}\n#{trace}</pre>]
  end

  def self.error(data)
    data = data.join("\n\n") if data.kind_of?(Array)
    return %[<pre style="color:red; background:#eee; padding:10px; ">Sinatra Lux error!\n\n#{data}</pre>]
  end

  def self.status(id, desc)
    what = case id
      when :forbiden;  [403, 'Forbiden']
      when :not_found; [404, 'Page not found']
      when :error;     [500, 'Server error']
      else
        Lux.error! "Unknown Lux.status #{id}"
    end

    Lux.sinatra.status what[0]
    Template.part('error', { :@short=>what[1], :@code=>what[0], :@descripton=>desc })
  end

  def self.dev?
    # Lux.sinatra.request.ip == '127.0.0.1' ? true : false
    !prod?
  end

  def self.prod?
    ENV['RAKE_ENV'].to_s[0,4] == 'prod' ? true : false
  end

  def self.irregular(sing, plur)
    @@irregulars[sing.to_s.downcase] = plur.to_s.downcase
    @@irregulars[plur.to_s.downcase] = sing.to_s.downcase
  end

  def self.irregulars
    @@irregulars
  end

  def self.host
    "#{sinatra.request.env['rack.url_scheme']}://#{sinatra.request.host}:#{sinatra.request.port}".sub(':80','')
  end

  def self.uid
    Thread.current[:uid_cnt] ||= 0
    "uid-#{Thread.current[:uid_cnt]+=1}"
  end

  def self.init(sin)
    Thread.current[:lux] = {}
    Thread.current[:lux][:sinatra] = sin
    Thread.current[:lux][:locals] = {}
  end

  def self.locals
    Thread.current[:lux][:locals]
  end

  def self.sinatra
    Thread.current[:lux][:sinatra]
  end

  def self.flash(key, value)
    Thread.current[:lux][:sinatra].session[:flash] = [key, value]
  end

  def self.flash_now(key, value)
    Thread.current[:lux][:flash] = [key, value]
  end

  def self.params
    unless Thread.current[:lux][:params]
      Thread.current[:lux][:params] = Thread.current[:lux][:sinatra].params.h
      Thread.current[:lux][:params].delete(:splat)
      Thread.current[:lux][:params].delete(:captures)
    end
    Thread.current[:lux][:params]
  end

  def self.redirect(location)
    Thread.current[:lux][:sinatra].redirect(location)
  end

  def self.request
    Thread.current[:lux][:sinatra].request
  end

  def self.session
    Thread.current[:lux][:sinatra].request.session
  end

  def self.no_cache
    Lux.sinatra.request.env['HTTP_CACHE_CONTROL'] == 'no-cache' ? true : false
  end

end

