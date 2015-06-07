class LuxRenderCell < LuxCell

  def self.mailer
    im =  Mailer.instance_methods.select{ |el| el.to_s.index('_preview') }.map{ |el| el.to_s.sub('_preview','') } 
    Template.render('lux/mailer', :@im=>im)
  end

  def self.api_root
    data = []
    
    @modules = []

    for api_file in Dir["./app/api/*.rb"].map{ |el| el.split('/').last.split('_api.rb').first }
      data = {}.h
      data[:name] = api_file.humanize.pluralize
      data[:location] = "/api/#{api_file.pluralize}"
      data[:actions]  = "#{api_file}_api".classify.constantize.actions

      @modules.push data
    end

    Template.render('lux/api', instance_variables_hash)
  end

  def self.get_api(*path)
      return Lux.error 'API error: action not defined' unless path[1]
      return LuxApi.run path[0], path[1]
  end

  def self.debug
    ret = []
    ret.push ">>> Routes"
    for file in `find ./app/cells | grep .rb`.split("\n").sort
      el = file.split(/\.|\//).reverse
      klass = "#{el[2]}/#{el[1]}".classify
      ret.push "\n  * #{klass}"
      for m in (klass.constantize.instance_methods - Object.instance_methods - [:render, :render_part, :sinatra])
        ret.push "    - #{m}"
      end
    end

    ret.push "\n\n\>>> Templates\n"

    last = nil
    for file in `find ./app/views`.split("\n").map{|el| el.sub('./app/views','')}.sort.reverse.select{|el| el.index('.') }
      elms = file.split('/')
      elms.shift
      if last != elms[0]
        ret.push "    * #{elms[0]}/"
        last = elms[0]
      end
      elms.shift
      ret.push "      - #{elms.join('/').sub('.haml','')}"
    end

    Template.render('lux/debug', :@data=>ret.join("\n") )
  end

end