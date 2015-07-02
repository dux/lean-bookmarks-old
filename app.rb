require './lux/init'

def resolve_main_app
  return Lux.status :forbiden, 'Only for registred users' unless User.current

  Lux.locals[:class] = @root_part.to_s.pluralize
  
  if @root_part == :part
    if @path_suffix
      klass, id = Crypt.decrypt(@path_suffix).split(':')
      @path.last = "_#{@path.last}"
      return Template.part(@path.join('/'), :object=>klass.constantize.get(id))
    end
  end

  return Main::StaticCell.resolve(@root_part) if [:search].index(@root_part)

  return "Main::#{@root_part.to_s.classify}Cell".constantize.resolve(*@path)
end

def resolve_promo_app
  if User.current
    Lux.flash :info, 'Only for guests'
    return redirect '/buckets'
  else
    return PromoCell.resolve(@root_part)
  end
end

def resolve_root
  User.current ? Template.render('main/index') : PromoCell.render(:index)
end

get '*' do
  # @body can be defined in before filter
  return @body if @body

  # debug development routes
  if Lux.dev?
    for el in [ [:lux, LuxRenderCell], [:api, LuxApi] ]
      return el[1].resolve(*@path) if @root_part == el[0]
    end
  end

  # root
  return resolve_root unless @root_part

  # guest routes
  return resolve_promo_app if [:set_password, :login, :css].index(@root_part)

  # main application routes
  return resolve_main_app if [:link, :note, :bucket, :user, :search, :part].index(@root_part)

  Lux.status :not_found, "Page not found not route /#{@root_part}"
end

post '/api/*' do
  return LuxApi.resolve(*@path)
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end