class Lux
  @@irregulars = {}

  def self.try(name)
    begin
      yield
    rescue
      Lux.report_error_html($!, name)
    end
  end  

  def self.report_error_html(o, name=nil)
    trace = o.backtrace.select{ |el| el.index('/app/') }.map{ |el| el.split('/app/', 2)[1] }.map{ |el| "- #{el}" }.join("\n")
    return %[<pre style="color:red; background:#eee; padding:10px; ">#{name || 'Undefined name'}\nError: #{o.message}\n#{trace}</pre>]
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
    ENV['SINATRA_ENV'][0,1] == 'd' ? true : false
  end

  def self.prod?
    !dev?
  end

  def self.irregular(sing, plur)
    @@irregulars[sing.to_s.downcase] = plur.to_s.downcase
    @@irregulars[plur.to_s.downcase] = sing.to_s.downcase
  end

  def self.irregulars
    @@irregulars
  end

  def self.sinatra
    Thread.current[:lux][:sinatra]
  end

  def self.params
    Thread.current[:lux][:sinatra].params
  end

  def self.host
    "#{sinatra.request.env['rack.url_scheme']}://#{sinatra.request.host}:#{sinatra.request.port}".sub(':80','')
  end

  @@uid = 0
  def self.uid
    "uid-#{++@@uid}"
  end

  def self.flash(key, value)
    Lux.sinatra.session[:flash] = [key, value]
  end

  def self.redirect(location)
    Lux.sinatra.redirect(location)
  end

end

