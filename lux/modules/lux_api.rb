class LuxApi

  def self.render_root
    data = []
    
    @modules = []

    for api_file in Dir["./app/api/*.rb"].map{ |el| el.split('/').last.split('_api.rb').first }
      data = {}.h
      data[:name] = api_file.humanize.pluralize
      data[:location] = "/api/#{api_file.pluralize}"
      data[:methods]  = "#{api_file}_api".classify.constantize.instance_methods - Object.methods

      @modules.push data
    end

    Template.part('api', instance_variables_hash)
  end

  def self.exec(path)
    name, id_or_method, method = path

    klass = eval("#{name.capitalize}Api")

    opts = { 
      params:{} 
    }

    if method
      opts[:params][:id] = id_or_method.to_i
      @ret = klass.new(opts).send(method)
    else
      @ret = klass.new(opts).send(id_or_method) 
    end

    ret = {}
    ret[:ip] = User.request.ip
    ret[:ip] = '127.0.0.1' if ret[:ip] == '::1'
    ret[:data] = @ret
    ret
  end


  def initialize(opts={})
    @opts = opts    
  end

  def params
    @opts[:params]
  end

end
