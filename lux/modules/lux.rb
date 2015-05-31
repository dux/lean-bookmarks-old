class Lux
  cattr_accessor :sinatra

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

end

