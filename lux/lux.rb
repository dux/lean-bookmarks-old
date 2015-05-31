class Lux
  cattr_accessor :sinatra
  cattr_accessor :in_production

  def self.try(name)
    begin
      yield
    rescue
      Lux.report_error_html($!, name)
    end
  end  

  def self.report_error_html(o, name=nil)
    trace = o.backtrace.reject{ |el| el.index('/.rbenv/') }.map{ |el| "- #{el}" }.join("\n")
    return %[<pre style="color:red; background:#eee; padding:10px; ">#{name || 'Undefined name'}\nError: #{o.message}\n#{trace}</pre>]
  end

  def self.error!(data)
    data = data.join("\n\n") if data.kind_of?(Array)
    return %[<pre style="color:red; background:#eee; padding:10px; ">Sinatra Lux error!\n\n#{data}</pre>]
  end

  def app(name)
    eval "#{name.to_s.capitalize}App.new"
  end

end

