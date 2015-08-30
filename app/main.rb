require './lux/init'

### GET abd POST

before do
  # for testing
  session[:u_id] = params[:usrid].to_i if Lux.dev? && params[:usrid]

  headers({ 'X-Frame-Options'=>'ALLOWALL' })

  if hash = params[:user_hash]
    usr_email = Crypt.decrypt(hash)
    usr = User.quick_create(usr_email)
    request.session[:u_id] = usr.id
    return redirect request.path
  end

  # disable subdomains
  url = Url.new(request.url)
  return redirect "#{url.proto}://#{url.domain}" if url.subdomain && url.subdomain != 'old'

  # r session[:u_id]

  # load user if there is session string
  if session[:u_id]
    begin
      User.current = User.find(session[:u_id])
    rescue
      session.delete(:u_id)
    end
  end
end

def get
  # debug development routes
  if Lux.dev?
    for el in [ [:lux, LuxRenderCell], [:api, LuxApi] ]
      return el[1].resolve(@path) if @root == el[0]
    end
  end
  
  # return ENV.to_json if @root == :env

  # root
  return resolve_root unless @root

  # add link
  return Main::LinkCell.render(:add) if @root == :add

  # main application routes
  return resolve_part if [:part].index(@root)

  # guest routes
  return resolve_promo_app if [:set_password, :login, :css].index(@root)

  @root = @root.to_s.singularize.to_sym
  # main application routes
  return resolve_main_app if [:link, :note, :bucket, :user, :domain, :search].index(@root)

  # plugin routes
  return resolve_plugin_app if [:plugin].index(@root)

  # admin routes
  return resolve_admin_app if [:admin].index(@root)

  Error.not_found("Page not found not route /#{@root}")
end

def post
  return LuxApi.resolve(@path) if @root == :api

  Lux.forbiden('POST request is not allowed in this route')
end

### Resolvers

def resolve_admin_app
  return 'Only for admins' unless User.current.is_admin

  return AdminCell.resolve(@path)
end

def resolve_main_app
  # return Lux.status :forbiden, 'Only for registred users' unless User.current
  return Error.unauthorized unless User.current

  Lux.locals[:class] = @root.to_s.pluralize
  
  return Main::StaticCell.resolve(@root) if [:search].index(@root)

  return "Main::#{@root.to_s.classify}Cell".constantize.resolve(@path)
end

def resolve_promo_app
  if User.current
    Lux.flash :info, 'Only for guests'
    return redirect '/buckets'
  else
    return PromoCell.resolve(@root)
  end
end

def resolve_plugin_app
  PluginCell.resolve(@path)
end

def resolve_root
  User.current ? Template.render('main/index') : PromoCell.render(:index)
end

def resolve_part
  object = nil
  if @namespace
    klass, id = Crypt.decrypt(@namespace).split(':')
    @path.last = "_#{@path.last}"
    object = klass.constantize.get(id)
  end
  Template.part(@path.join('/'), :object=>object)
end
