class Page
  @@irregulars = {}

  def self.try(name)
    begin
      yield
    rescue
      Page.report_error_html($!, name)
    end
  end  

  def self.report_error_html(o, name=nil)
    trace = o.backtrace.select{ |el| el.index('/app/') }.map{ |el| el.split('/app/', 2)[1] }.map{ |el| "- #{el}" }.join("\n")
    msg   = o.message.gsub('","',%[",\n "])
    return %[<pre style="color:red; background:#eee; padding:10px; font-family:'Lucida Console'; line-height:14pt; font-size:10pt;">#{name || 'Undefined name'}\nError: #{msg}\n#{trace}</pre>]
  end

  def self.once(name, &block)
    Thread.current[:lux][:_once_hash] ||= {}
    unless Thread.current[:lux][:_once_hash][name]
      Thread.current[:lux][:_once_hash][name] = true
      yield
    end
  end

  def self.etag(*args)
    ret = []
    ret.push Page.request.url

    for el in args
      if el.respond_to? :updated_at
        ret.push "#{el.class.name}-#{el.id}-#{el.updated_at.to_i}"
      elsif el.kind_of? Symbol
        ret.push el.to_s
      elsif el.respond_to? :id
        ret.push "#{el.class.name}:#{el.id}" rescue ''
      else
        ret.push ret.to_s rescue 'nil'
      end
    end

    etag = %[W/"#{Crypt.md5(ret.join('-'))}"]
    
    if etag == Page.sinatra.request.env['HTTP_IF_NONE_MATCH']
      Page.status(304)
      Thread.current[:lux][:halt] = true
      return true
    end
    
    Page.sinatra.response.headers['ETag'] = etag

    false
  end

  def self.root
    __FILE__.sub('/lux/modules/page.rb','')
  end

  def self.dev?
    !prod?
  end

  def self.prod?
    ENV['RACK_ENV'].to_s[0,4] == 'prod' ? true : false
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

  def self.no_cache?
    Page.sinatra.request.env['HTTP_CACHE_CONTROL'] == 'no-cache' ? true : false
  end

  def self.body=(data)
    Thread.current[:lux][:body] = data
  end

  def self.body
    Thread.current[:lux][:body]
  end

  def self.status(s)
    Thread.current[:lux][:sinatra].status(s)
  end

end

