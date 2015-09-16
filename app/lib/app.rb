class App

  def self.name
    'Demo app'
  end

  def self.base_url
   Page.sinatra.request.protocol + Page.sinatra.request.host_with_port
  end

end