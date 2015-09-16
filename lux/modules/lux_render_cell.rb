class LuxRenderCell < LuxCell

  # usuaal usage in main router
  #  when :lux
  #    return LuxRenderCell.dev_mount(*@path)
  def self.resolve(*path)
    return Template.render('lux/index') unless path.first
    return dev_mount_api_root if path.first == 'api'
    return dev_mount_mailer(path[1]) if path.first == 'mailer'
    return dev_mount_debug if path.first == 'debug'

    Page.status :error, "<b>#{path[0]}</b> is not supported route part for /lux route"
  end

  # renders list of emails in /mailer or perticular template in /mailer/[tempplate_name]_preview
  def self.dev_mount_mailer(template=nil)
    
    if template # we are in iframe
      method_name = "#{template}_preview"
      # return Mailer.render(method_name) if Mailer.respond_to?(method_name)

      if Page.sinatra.params['send']
        Mailer.send(method_name).deliver
        return 'Email sent'
      else
        return Mailer.send(method_name).body
      end

      # return Mailer.send(method_name).body if Mailer.respond_to?(method_name)
      return Error.server("There is no class method >><b>#{method_name}</b><< in Mailer class.\n\nMailer.#{method_name}() failed")
    end

    # if Page.params[:preview] && Page.params[:send]
    #   Mailer.send(Page.params[:preview])
    #   Page.sinatra.redirect Url.current.delete(:send).to_s
    # end

    im =  Mailer.methods.select{ |el| el.to_s.index('_preview') }.map{ |el| el.to_s.sub('_preview','') } 
    Template.render('lux/mailer', :@mailer_methods=>im)
  end

  # API methods and functions
  def self.dev_mount_api_root
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
      return Error.server('API error: action not defined') unless path[1]
      return LuxApi.run path[0], path[1]
  end

  def self.dev_mount_debug
    ret = []
    ret.push ">>> Routes"
    for file in `find ./app/cells | grep .rb`.split("\n").sort
      el = file.split(/\.|\//).reverse
      klass = "#{el[2]}/#{el[1]}".classify
      ret.push "\n  * #{klass}"
      for m in (klass.constantize.instance_methods - Object.instance_methods - [:render, :render_part, :sinatra, :params, :request])
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