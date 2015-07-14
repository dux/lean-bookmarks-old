class Error
  class << self

    def status(code, desc=nil)
      return unauthorized(desc) if code == 401
      return not_found(desc) if code == 404
      return server(desc) if code == 500

      r "Unknown error code #{code}"
    end

    def render(code, name, desc)
      Lux.sinatra.status code
      Template.part('error', { :@short=>'Unauthorized', :@code=>code, :@descripton=>desc })
    end

    def unauthorized(desc=nil)
      desc ||= 'You are not unauthorized to access this page, please login on <a href="/login">login</a> page'
      render 401, 'Unauthorized', desc
    end

    def forbiden(desc=nil)
      desc ||= 'You are not allowed to make this kind of request'
      render 403, 'Forbiden', desc
    end

    def not_found(desc=nil)
      desc ||= 'Page was not found'
      render 404, 'Not found', desc
    end

    def server(desc=nil)
      Lux.sinatra.status 500
      data = "Server error (500)\n\n#{desc}"
      return %[<html><head><title>Server error (500)</title></head><body style="background:#fdd;"><pre style="color:red; padding:10px; font-size:14pt;">#{data}</pre></body></html>]
    end

  end
end