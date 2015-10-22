require './lux/init'

### GET abd POST

before do
  # for testing
  session[:u_id] = params[:usrid].to_i if Page.dev? && params[:usrid]

  headers({ 'X-Frame-Options'=>'ALLOWALL' })

  if hash = params[:user_hash]
    usr = User.where(token:hash).first || User.quick_create((Crypt.decrypt(hash) rescue 'bang'))
    if usr
      session[:u_id] = usr.id
      u = Url.current
      u.delete(:user_hash)
      return redirect u.relative
    end
    return redirect request.path
  end

  # disable subdomains
  url = Url.new(request.url)
  return redirect "#{url.proto}://#{url.domain}" if url.subdomain && url.subdomain != 'old'

  # load user if there is session string
  if session[:u_id]
    begin
      User.current = User.find(session[:u_id].to_i)
    rescue
      session.delete(:u_id)
    end
  end
end

def get
  # debug development routes
  if Page.dev?
    for el in [ [:lux, LuxRenderCell], [:api, LuxApi] ]
      return el[1].resolve(@path) if @root == el[0]
    end
  end
  
  return DomainThumb.render(@path[0]) if @root == :t;

  # root
  return resolve_root unless @root

  if @namespace && @root == :bucket && @path[0]
    if Crypt.sha1(@path[0].to_i) == @namespace
      return Main::BucketCell.render(:show, @path[0])
    end
  end

   # guest routes
  unless User.current
    return resolve_promo_app if [:set_password, :login, :css].index(@root)
    return PromoCell.render(:login)
  end

  # add link
  return Main::LinkCell.render(:add) if @root == :add

  # main application routes
  return resolve_part if [:part].index(@root)

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

  Page.forbiden('POST request is not allowed in this route')
end

### Resolvers

def resolve_admin_app
  return 'Only for admins' unless User.current.is_admin

  return AdminCell.resolve(@path)
end

def resolve_main_app
  # return Page.status :forbiden, 'Only for registred users' unless User.current
  # should not be triggered
  return Error.unauthorized unless User.current

  Page.locals[:class] = @root.to_s.pluralize
  
  return Main::StaticCell.resolve(@root) if [:search].index(@root)

  return "Main::#{@root.to_s.classify}Cell".constantize.resolve(@path)
end

def resolve_promo_app
  if User.current
    Page.flash :info, 'Only for guests'
    return redirect '/buckets'
  else
    return PromoCell.resolve(@root)
  end
end

def resolve_plugin_app
  PluginCell.resolve(@path)
end

def resolve_root
  User.current ? Main::LinkCell.render(:home) : PromoCell.render(:index)
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
