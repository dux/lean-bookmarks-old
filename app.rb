require './lux/init'

get '*' do
  # @body can be defined in before filter
  return @body if @body

  # root
  return User.current ? Template.render('main/index') : PromoCell.render(:index) unless @root_part

  # debug development routes
  if Lux.dev?
    for el in [ [:lux, LuxRenderCell], [:api, LuxApi] ]
      return el[1].resolve(*@path) if @root_part == el[0]
    end
  end

  # base root calls
  return PromoCell.resolve(@root_part) if [:set_password, :login, :css].index(@root_part)

  if @root_part == :part
    if @path_suffix
      klass, id = Crypt.decrypt(@path_suffix).split(':')
      # eval "@#{klass.tableize.singularize} = #{klass}.get(id)"
      @path.last = "_#{@path.last}"
      return Template.part(@path.join('/'), :object=>klass.constantize.get(id))
    end
  end

  # application routes
  if [:link, :note, :bucket, :user].index(@root_part)
    return Lux.status :forbiden, 'Only for registred users' unless User.current

    Lux.locals[:class] = @root_part.to_s.pluralize
    
    return "Main::#{@root_part.to_s.classify}Cell".constantize.resolve(*@path)
  end

  # main base routes
  return Template.render("main/#{@root_part}") if [:search].index(@root_part)

  Lux.status :not_found, "Page not found not route /#{@root_part}"
end

post '/api/*' do
  return LuxApi.resolve(*@path)
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end